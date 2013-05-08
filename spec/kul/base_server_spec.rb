require 'spec_helper'

describe Kul::BaseServer do

  describe '#request_handler_method' do
    it 'creates an app from the request params' do
      app = double(:handle_request => 'bar')
      Kul::FrameworkFactory.should_receive(:create_app).with('foo').and_return app
      Kul::BaseServer.new.request_handler_method.call({ app: 'foo' })
    end
    it 'calls handle_request with request_params on the app' do
      app = double
      app.should_receive(:handle_request).with({}).and_return 'bar'
      Kul::FrameworkFactory.stub(:create_app => app)
      Kul::BaseServer.new.request_handler_method.call({})
    end
    it 'returns the response' do
      app = double(:handle_request => 'bar')
      Kul::FrameworkFactory.stub(:create_app => app)
      test = Kul::BaseServer.new.request_handler_method.call({})
      test.should == 'bar'
    end
  end

end