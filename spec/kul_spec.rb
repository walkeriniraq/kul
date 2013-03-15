require 'spec_helper'

describe 'Kul' do
  include Rack::Test::Methods

  def app
    Kul::Server
  end

  it 'serves the favicon' do
    get '/favicon.ico'
    last_response.status.should == 200
  end

  it 'serves an html file' do
    get '/foo/bar/test'
    last_response.status.should == 200
    last_response.body.should == "This is my test"
  end

end