require 'spec_helper'

describe Kul::BaseServer do

  describe '#request_handler' do
    it 'adds itself to the request' do
      request = Kul::RequestContext.new
      server = Kul::BaseServer.new
      request.should_receive(:server=).with(server)
      server.request_handler(request)
    end

    it 'creates an app from the request params' do
      app = double(:handle_request => 'bar')
      Kul::FrameworkFactory.should_receive(:create_app).with('foo').and_return app
      Kul::BaseServer.new.request_handler(Kul::RequestContext.new app: 'foo')
    end
    it 'calls handle_request with request_params on the app' do
      app = double
      request = Kul::RequestContext.new
      app.should_receive(:handle_request).with(request).and_return 'bar'
      Kul::FrameworkFactory.stub(:create_app => app)
      Kul::BaseServer.new.request_handler(request)
    end
    it 'returns the response' do
      app = double(:handle_request => 'bar')
      Kul::FrameworkFactory.stub(:create_app => app)
      test = Kul::BaseServer.new.request_handler(Kul::RequestContext.new)
      test.should == 'bar'
    end
  end

end