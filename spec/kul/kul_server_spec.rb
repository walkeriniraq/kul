require 'spec_helper'

describe Kul::Server do
  context '.route_path' do
    it 'returns 404 when the file does not exist' do
      inside_test_server do
        expect { Kul::Server.new.route_path 'not_exist', {} }.to raise_exception(Sinatra::NotFound)
      end
    end

    it 'returns the rendered file' do
      inside_test_server do
        test = Kul::Server.new.route_path 'foo/bar/test_erb', {}
        test.should be
        test.should == 'This is my test'
      end
    end

    context 'request context provided to the template' do
      it 'includes the server'
      it 'includes the app'
      it 'includes request parameters'
    end
  end

  context '.route_action' do
    it 'raises NotFound when the controller does not exist' do
      inside_test_server do
        expect { Kul::Server.new.route_action 'app' => 'foo', 'controller' => 'foo', 'action' => 'action' }.to raise_exception(Sinatra::NotFound)
      end
    end

    it 'raises NotFound when there is no action method' do
      controller = stub
      controller.should_receive(:respond_to?).twice { false }
      Kul::ServerFactory.should_receive(:create_controller).with('foo', 'bar') { controller }
      expect { Kul::Server.new.route_action 'app' => 'foo', 'controller' => 'bar', 'action' => 'not_exist' }.to raise_exception(Sinatra::NotFound)
    end

    context 'when process_action is not present' do
      it 'sends the action directly to the class' do
        inside_test_server do
          test = Kul::Server.new.route_action 'app' => 'foo', 'controller' => 'baz', 'action' => 'some_action'
          test.should == 'Some crazy thing'
        end
      end
    end

    context 'when process_action is present' do
      it 'forwards action request' do
        controller = stub
        controller.should_receive(:process_action).with(an_instance_of Hash) { 'Some crazy thing' }
        Kul::ServerFactory.should_receive(:create_controller).with('foo', 'bar') { controller }
        test = Kul::Server.new.route_action 'app' => 'foo', 'controller' => 'bar', 'action' => 'some_action'
        test.should == 'Some crazy thing'
      end
    end
  end

end