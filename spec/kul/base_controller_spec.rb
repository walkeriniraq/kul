require 'spec_helper'

describe Kul::BaseController do
  context '.process_action' do
    it 'returns 404 when neither the method nor the file exists' do
      inside_test_server do
        controller = Kul::BaseController.new
        expect do
          controller.process_action 'app' => 'foo', 'controller' => 'bar', 'action' => 'not_exist'
        end.to raise_exception(Sinatra::NotFound)
      end
    end

    it 'renders an html.erb when the method does not exist' do
      inside_test_server do
        controller = Kul::BaseController.new
        test = controller.process_action 'app' => 'foo', 'controller' => 'bar', 'action' => 'test_erb'
        test.should be
        test.should == 'This is my test'
      end
    end

    it 'renders the return from the method if it exists' do
      inside_test_server do
        load './foo/bar/bar_controller.rb'
        controller = BarController.new
        test = controller.process_action 'app' => 'foo', 'controller' => 'bar', 'action' => 'test_action'
        test.should be
        test.should == 'this is a nifty test action'
      end
    end

    context 'request context provided to the method' do
      it 'includes the server'
      it 'includes the app'
      it 'includes request parameters'
      it 'includes the request object'
    end
  end
end