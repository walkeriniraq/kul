require 'spec_helper'

describe Kul::RequestProcessor do
  include Rack::Test::Methods

  def app
    Kul::RequestProcessor.new
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

  context 'request with a file and an extension' do
    it 'creates a request context with :path' do
      Kul::RequestContext.should_receive(:new).with(hash_including(:path => 'foo/bar')) {}
      get '/foo/bar.html'
    end
    it 'creates a request context with :extension' do
      Kul::RequestContext.should_receive(:new).with(hash_including(:extension => 'html')) {}
      get '/foo/bar.html'
    end
    it 'creates a request context with :params' do
      Kul::RequestContext.should_receive(:new).with(hash_containing(:params => { 'foo' => 'bar', 'bar' => 'baz' })) {}
      get '/foo/bar.html?foo=bar&bar=baz'
    end
    it 'gets a router from the framework factory'
    it 'passes the request context to the router'
    it 'renders the response from the router'
  end

end