require 'spec_helper'

describe Kul::BaseServer do
  context '#route_path' do
    it 'returns 404 when the file does not exist' do
      inside_test_server do
        expect { Kul::BaseServer.new.route_path 'not_exist', {} }.to raise_exception(Sinatra::NotFound)
      end
    end

    it 'returns the rendered file' do
      inside_test_server do
        test = Kul::BaseServer.new.route_path 'foo/bar/test_erb', {}
        test.should be
        test.should == 'This is my test'
      end
    end

    context 'request context provided to the template' do
      it 'includes the server' do
        # this test is a bit brute force
        inside_test_server do
          server = Kul::BaseServer.new
          server.instance_variable_set('@blah', 'foobar')
          test = server.route_path 'foo/bar/server_context_test', {}
          test.should == 'foobar'
        end
      end

      it 'includes the app' do
        inside_test_server do
          test = Kul::BaseServer.new.route_path 'foo/bar/app_context_test', {}
          test.should == 'Used in server_spec - .route_path - includes the app'
        end
      end

      it 'includes request parameters' do
        inside_test_server do
          test = Kul::BaseServer.new.route_path 'foo/bar/params_context_test', {blah: 'This is a test'}
          test.should == 'This is a test'
        end
      end
    end
  end

  context '#find_app' do
    it 'returns the path from the string passed in' do
      test = Kul::BaseServer.new.find_app('foo/bar/blah')
      test.should be
      test.should == 'foo'
    end

    it 'returns nil when there is no separator' do
      test = Kul::BaseServer.new.find_app('foo')
      test.should be_nil
    end
  end

  context '#route_action' do
    context 'when the controller module does not exist' do
      it 'returns a NotFound response when there is no template' do
        inside_test_server do
          Kul::FrameworkFactory.should_receive(:find_module).with('foo', 'not_exist').once.and_return nil
          request = Kul::RequestContext.new params: { 'app' => 'foo', 'controller' => 'not_exist', 'action' => 'action' }
          test = Kul::BaseServer.new.route_action request
          test.should be_a ResponseNotFound
        end
      end

      it 'renders the template when it exists' do
        inside_test_server do
          Kul::FrameworkFactory.should_receive(:find_module).with('foo', 'bar').once.and_return nil
          request = Kul::RequestContext.new params: { 'app' => 'foo', 'controller' => 'bar', 'action' => 'action' }
          test = Kul::BaseServer.new.route_action request
          test.should be_a ResponseRenderTemplate
        end
      end
    end
    context 'when the controller module exists' do
      module Foo
        module Bar
          def string_action
            'this is a test'
          end
          def nil_action
          end
          def render_action
            ResponseRenderTemplate.new({})
          end
        end
      end

      it 'returns NotFound response when the method does not exist' do
        Kul::FrameworkFactory.should_receive(:find_module).with('foo', 'bar').once.and_return Foo::Bar
        request = Kul::RequestContext.new params: { 'app' => 'foo', 'controller' => 'bar', 'action' => 'not_exist' }
        test = Kul::BaseServer.new.route_action request
        test.should be_a ResponseNotFound
      end

      it 'returns Text response when a string comes back from the action' do
        Kul::FrameworkFactory.should_receive(:find_module).with('foo', 'bar').once.and_return Foo::Bar
        request = Kul::RequestContext.new params: { 'app' => 'foo', 'controller' => 'bar', 'action' => 'string_action' }
        test = Kul::BaseServer.new.route_action request
        test.should be_a ResponseText
        test.text.should == 'this is a test'
      end

      it 'returns the response when a response comes back from the action' do
        Kul::FrameworkFactory.should_receive(:find_module).with('foo', 'bar').once.and_return Foo::Bar
        request = Kul::RequestContext.new params: { 'app' => 'foo', 'controller' => 'bar', 'action' => 'render_action' }
        test = Kul::BaseServer.new.route_action request
        test.should be_a ResponseRenderTemplate
      end

      it 'returns an error response when nil comes back from the action' do
        Kul::FrameworkFactory.should_receive(:find_module).with('foo', 'bar').once.and_return Foo::Bar
        request = Kul::RequestContext.new params: { 'app' => 'foo', 'controller' => 'bar', 'action' => 'nil_action' }
        test = Kul::BaseServer.new.route_action request
        test.should be_a ResponseError
      end
    end
  end
end