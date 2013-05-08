require 'spec_helper'

describe Kul::BaseApp do
  shared_examples 'controller or action does not exist' do
    context ':action.html exists' do
      it 'routes to :action.html'
    end
    context ':action.html does not exist' do
      it 'routes to /:action/index.html'
    end
  end

  describe '#construct_pathname' do
    context 'when the app pathname is empty' do
      it 'returns the path and extension'
    end
    it 'returns the app, path, and extension'
  end

  describe '#request_handler_method' do
    context 'the request has a controller arg' do
      it 'returns the response from the action'
      context 'the controller does not exist' do
        it_behaves_like 'controller or action does not exist'
      end
      context 'the action does not exist' do
        it_behaves_like 'controller or action does not exist'
      end
    end
    context 'no controller arg' do
      it 'returns a render file response' do
        inside_test_server do
          request = Kul::RequestContext.new :path => 'index', :extension => 'html'
          test = Kul::BaseApp.new.request_handler(request)
          test.should be_a ResponseRenderFile
        end
      end
      it 'has the name of the file to render' do
        inside_test_server do
          request = Kul::RequestContext.new :path => 'index', :extension => 'html'
          test = Kul::BaseApp.new.request_handler(request)
          test.file.should == 'index.html'
        end
      end
      context 'when the file does not exist' do
        it 'returns 404' do
          inside_test_server do
            request = Kul::RequestContext.new :path => 'not_exist', :extension => 'html'
            test = Kul::BaseApp.new.request_handler(request)
            test.should be_a ResponseNotFound
          end
        end
      end
      context 'when the extension is not in the router' do
        it 'returns 404' do
          inside_test_server do
            router = double(:handle_extension? => false)
            request = Kul::RequestContext.new :path => 'server', :extension => 'rb'
            test = Kul::BaseApp.new(router: router).request_handler(request)
            test.should be_a ResponseNotFound
          end
        end
      end
      context 'when given a list of routing instructions' do
        let(:router) do
          double(:handle_extension? => true,
                 :routing => [{extension: 'html.erb', instruction: :template},
                              {extension: 'html', instruction: :file}])
        end
        it 'returns a render template response' do
          inside_test_server do
            request = Kul::RequestContext.new :path => 'views/test', :extension => 'html'
            test = Kul::BaseApp.new(router: router).request_handler(request)
            test.should be_a ResponseRenderTemplate
          end
        end
        it 'template response has the correct filename' do
          inside_test_server do
            request = Kul::RequestContext.new :path => 'views/test', :extension => 'html'
            test = Kul::BaseApp.new(router: router).request_handler(request)
            test.file.should == 'views/test.html.erb'
          end
        end
        it 'returns a render file response' do
          inside_test_server do
            request = Kul::RequestContext.new :path => 'index', :extension => 'html'
            test = Kul::BaseApp.new(router: router).request_handler(request)
            test.should be_a ResponseRenderFile
          end
        end
        it 'file response has the correct filename' do
          inside_test_server do
            request = Kul::RequestContext.new :path => 'index', :extension => 'html'
            test = Kul::BaseApp.new(router: router).request_handler(request)
            test.file.should == 'index.html'
          end
        end
      end
      context 'when there is a custom routing instruction' do
        it 'returns the correct response'
      end
      context 'when there is an invalid routing instruction' do
        it 'throws an error'
      end
    end
  end

  #context '#route_path' do
  #  it 'returns 404 when the file does not exist' do
  #    inside_test_server do
  #      expect { Kul::BaseServer.new.route_path 'not_exist', {} }.to raise_exception(Sinatra::NotFound)
  #    end
  #  end
  #
  #  it 'returns the rendered file' do
  #    inside_test_server do
  #      test = Kul::BaseServer.new.route_path 'foo/bar/test_erb', {}
  #      test.should be
  #      test.should == 'This is my test'
  #    end
  #  end
  #
  #  context 'request context provided to the template' do
  #    it 'includes the server' do
  #      # this test is a bit brute force
  #      inside_test_server do
  #        server = Kul::BaseServer.new
  #        server.instance_variable_set('@blah', 'foobar')
  #        test = server.route_path 'foo/bar/server_context_test', {}
  #        test.should == 'foobar'
  #      end
  #    end
  #
  #    it 'includes the app' do
  #      inside_test_server do
  #        test = Kul::BaseServer.new.route_path 'foo/bar/app_context_test', {}
  #        test.should == 'Used in server_spec - .route_path - includes the app'
  #      end
  #    end
  #
  #    it 'includes request parameters' do
  #      inside_test_server do
  #        test = Kul::BaseServer.new.route_path 'foo/bar/params_context_test', {blah: 'This is a test'}
  #        test.should == 'This is a test'
  #      end
  #    end
  #  end
  #end
  #
  #context '#find_app' do
  #  it 'returns the path from the string passed in' do
  #    test = Kul::BaseServer.new.find_app('foo/bar/blah')
  #    test.should be
  #    test.should == 'foo'
  #  end
  #
  #  it 'returns nil when there is no separator' do
  #    test = Kul::BaseServer.new.find_app('foo')
  #    test.should be_nil
  #  end
  #end
  #
  #context '#route_action' do
  #  context 'when the controller module does not exist' do
  #    it 'returns a NotFound response when there is no template' do
  #      inside_test_server do
  #        Kul::FrameworkFactory.should_receive(:find_module).with('foo', 'not_exist').once.and_return nil
  #        request = Kul::RequestContext.new params: { 'app' => 'foo', 'controller' => 'not_exist', 'action' => 'action' }
  #        test = Kul::BaseServer.new.route_action request
  #        test.should be_a ResponseNotFound
  #      end
  #    end
  #
  #    it 'renders the template when it exists' do
  #      inside_test_server do
  #        Kul::FrameworkFactory.should_receive(:find_module).with('foo', 'bar').once.and_return nil
  #        request = Kul::RequestContext.new params: { 'app' => 'foo', 'controller' => 'bar', 'action' => 'action' }
  #        test = Kul::BaseServer.new.route_action request
  #        test.should be_a ResponseRenderTemplate
  #      end
  #    end
  #  end
  #  context 'when the controller module exists' do
  #    module Foo
  #      module Bar
  #        def string_action
  #          'this is a test'
  #        end
  #        def nil_action
  #        end
  #        def render_action
  #          ResponseRenderTemplate.new({})
  #        end
  #      end
  #    end
  #
  #    it 'returns NotFound response when the method does not exist' do
  #      Kul::FrameworkFactory.should_receive(:find_module).with('foo', 'bar').once.and_return Foo::Bar
  #      request = Kul::RequestContext.new params: { 'app' => 'foo', 'controller' => 'bar', 'action' => 'not_exist' }
  #      test = Kul::BaseServer.new.route_action request
  #      test.should be_a ResponseNotFound
  #    end
  #
  #    it 'returns Text response when a string comes back from the action' do
  #      Kul::FrameworkFactory.should_receive(:find_module).with('foo', 'bar').once.and_return Foo::Bar
  #      request = Kul::RequestContext.new params: { 'app' => 'foo', 'controller' => 'bar', 'action' => 'string_action' }
  #      test = Kul::BaseServer.new.route_action request
  #      test.should be_a ResponseText
  #      test.text.should == 'this is a test'
  #    end
  #
  #    it 'returns the response when a response comes back from the action' do
  #      Kul::FrameworkFactory.should_receive(:find_module).with('foo', 'bar').once.and_return Foo::Bar
  #      request = Kul::RequestContext.new params: { 'app' => 'foo', 'controller' => 'bar', 'action' => 'render_action' }
  #      test = Kul::BaseServer.new.route_action request
  #      test.should be_a ResponseRenderTemplate
  #    end
  #
  #    it 'returns an error response when nil comes back from the action' do
  #      Kul::FrameworkFactory.should_receive(:find_module).with('foo', 'bar').once.and_return Foo::Bar
  #      request = Kul::RequestContext.new params: { 'app' => 'foo', 'controller' => 'bar', 'action' => 'nil_action' }
  #      test = Kul::BaseServer.new.route_action request
  #      test.should be_a ResponseError
  #    end
  #  end
  #end
end
