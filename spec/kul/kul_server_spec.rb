require 'spec_helper'

describe Kul::BaseServer do
  context '.route_path' do
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
        # given this particular set of objects, I'm not really sure how else to test this
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
          test = Kul::BaseServer.new.route_path 'foo/bar/params_context_test', { blah: 'This is a test' }
          test.should == 'This is a test'
        end
      end
    end
  end

  context '.find_app' do
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

  context '.route_action' do
    it 'raises NotFound when the controller does not exist' do
      inside_test_server do
        expect { Kul::BaseServer.new.route_action 'app' => 'foo', 'controller' => 'foo', 'action' => 'action' }.to raise_exception(Sinatra::NotFound)
      end
    end

    it 'raises NotFound when there is no action method' do
      controller = stub
      controller.should_receive(:respond_to?).twice { false }
      Kul::FrameworkFactory.should_receive(:create_controller).with('foo', 'bar') { controller }
      expect { Kul::BaseServer.new.route_action 'app' => 'foo', 'controller' => 'bar', 'action' => 'not_exist' }.to raise_exception(Sinatra::NotFound)
    end

    context 'when process_action is not present' do
      it 'sends the action directly to the class' do
        inside_test_server do
          test = Kul::BaseServer.new.route_action 'app' => 'foo', 'controller' => 'baz', 'action' => 'some_action'
          test.should == 'Some crazy thing'
        end
      end
    end

    context 'when process_action is present' do
      it 'forwards action request' do
        controller = stub
        controller.should_receive(:process_action).with(an_instance_of Hash) { 'Some crazy thing' }
        Kul::FrameworkFactory.should_receive(:create_controller).with('foo', 'bar') { controller }
        test = Kul::BaseServer.new.route_action 'app' => 'foo', 'controller' => 'bar', 'action' => 'some_action'
        test.should == 'Some crazy thing'
      end
    end
  end

end