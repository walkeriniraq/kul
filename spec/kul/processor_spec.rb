require 'spec_helper'

describe Kul::Processor do
  include Rack::Test::Methods

  def app
    Kul::Processor.new
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

  context '/' do
    it 'passes the path to the request context' do
      Kul::FrameworkFactory.should_receive(:create_request) do |opts|
        opts[:path].should == ''
        Kul::RequestContext.new(opts)
      end
      get '/'
    end
  end

end