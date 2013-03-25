require 'spec_helper'
require 'test_app_helper'

describe Kul::Router do
  include Rack::Test::Methods

  def app
    Kul::Router.new
  end

  context 'explicit routing' do
  end

  context 'implicit server routing' do
    context '.rb files' do
      it 'returns 404' do
        inside_test_app do
          get '/server.rb'
          last_response.should be_not_found
        end
      end
    end

    context 'favicon.ico' do
      it 'returns ok status when file is present' do
        inside_test_app do
          get '/favicon.ico'
          last_response.should be_ok
        end
      end

      it 'returns 404 when file is not present' do
        inside_empty_app do
          get '/favicon.ico'
          last_response.should be_not_found
          last_response.body.should be_empty
        end
      end
    end

    context 'html files' do
      it 'routes to the server when no html file present' do
        server_connection = stub
        server_connection.should_receive(:route_path).with("non_exist", an_instance_of(Hash)) { "foo" }
        Kul::ServerConnection.should_receive(:new) { server_connection }
        #Kul::ServerConnection.should_receive(:route_to_server).with("non_exist", an_instance_of(Hash)) { "foo" }
        get '/non_exist.html'
        last_response.should be_ok
        last_response.body.should == "foo"
      end

      it 'sends the html file content if it exists' do
        inside_test_app do
          get '/no_app/test.html'
          last_response.should be_ok
          last_response.body.should be == 'Some random text'
        end
      end
    end

    context 'controller action' do
      it 'gets routed to the server' do
        server_connection = stub
        server_connection.should_receive(:route_action).with(an_instance_of(Hash)) { "foo" }
        Kul::ServerConnection.should_receive(:new) { server_connection }
        get '/foo/bar/baz'
        last_response.should be_ok
        last_response.body.should == "foo"
      end

    #  it 'returns 404 when there is no action method' do
    #    get '/foo/bar/notexist'
    #    last_response.should be_not_found
    #  end
    #  it 'sends the action when process_action is not there' do
    #    get '/foo/baz/some_action'
    #    last_response.should be_ok
    #  end
    #  it 'sends process_action when it is implemented'
    #  it 'returns ok when the method returns'
    #  it 'returns 404 when the controller does not exist'
    end
  end

end