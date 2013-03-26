require 'spec_helper'

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
        inside_test_server do
          get '/server.rb'
          last_response.should be_not_found
        end
      end
    end

    context 'favicon.ico' do
      it 'returns ok status when file is present' do
        inside_test_server do
          get '/favicon.ico'
          last_response.should be_ok
        end
      end

      it 'returns 404 when file is not present' do
        inside_empty_server do
          get '/favicon.ico'
          last_response.should be_not_found
          last_response.body.should be_empty
        end
      end
    end

    context 'html files' do
      it 'sends the html file content if it exists' do
        inside_test_server do
          get '/no_app/test.html'
          last_response.should be_ok
          last_response.body.should be == 'Some random text'
        end
      end

      it 'routes to the server when no html file present' do
        server = stub
        server.should_receive(:route_path).with("non_exist", an_instance_of(Hash)) { "foo" }
        Kul::ServerFactory.should_receive(:create_server) { server }
        get '/non_exist.html'
        last_response.should be_ok
        last_response.body.should == "foo"
      end
    end

    context 'controller action' do
      it 'gets routed to the server' do
        server = stub
        server.should_receive(:route_action).with(an_instance_of(Hash)) { "foo" }
        Kul::ServerFactory.should_receive(:create_server) { server }
        get '/foo/bar/baz'
        last_response.should be_ok
        last_response.body.should == "foo"
      end

    end
  end

end