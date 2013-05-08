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

  describe '#do_route' do
    it 'builds a request context with the context_params' do
      context  = double
      response = double(:render => '')
      server   = double(:handle_request => response)
      Kul::FrameworkFactory.stub(:create_server).and_return server
      Kul::RequestContext.should_receive(:new).with(:place => 'here', :time => 'now').and_return context
      Kul::RequestProcessor.do_route :place => 'here', :time => 'now'
    end
    it 'passes the request context to a server' do
      server   = double
      context  = double
      response = double(:render => '')
      Kul::RequestContext.stub(:new).and_return context
      Kul::FrameworkFactory.stub(:create_server).and_return server
      server.should_receive(:handle_request).with(context).and_return response
      Kul::RequestProcessor.do_route
    end
    it 'renders and returns the response from the server' do
      response = double(:render => 'this is my test')
      server   = double(:handle_request => response)
      Kul::FrameworkFactory.stub(:create_server).and_return server
      test = Kul::RequestProcessor.do_route
      test.should == 'this is my test'
    end
    it 'returns response.to_s if response has no render method' do
      response = double
      server   = double(:handle_request => response)
      Kul::FrameworkFactory.stub(:create_server).and_return server
      response.should_receive(:to_s).and_return('this is a different test')
      test = Kul::RequestProcessor.do_route
      test.should == 'this is a different test'
    end
  end

  context 'request for the root path' do
    request_string = '/?foo=bar'
    { path: 'index', extension: 'html', params: { 'foo' => 'bar'} }.each do |key, value|
      it "sets #{key} to #{value}" do
        Kul::RequestContext.should_receive(:new).with(hash_containing(key => value))
        get request_string
      end
    end
  end

  context 'request for an app path' do
    request_string = '/foo?bar=baz'
    { app: 'foo', path: 'index', extension: 'html' }.each do |key, value|
      it "sets #{key} to #{value}" do
        Kul::RequestContext.should_receive(:new).with(hash_containing(key => value))
        get request_string
      end
    end
  end

  context 'request with a file and an extension' do
    request_string = '/foo/bar.html?foo=bar&bar=baz'
    { app: 'foo', path: 'bar', extension: 'html', params: { 'foo' => 'bar', 'bar' => 'baz' } }.each do |key, value|
      it "sets #{key} to #{value}" do
        Kul::RequestContext.should_receive(:new).with(hash_containing(key => value))
        get request_string
      end
    end
  end

  context 'request for an app sub-path' do
    request_string = '/foo/bar?foo=bar&bar=baz'
    { app: 'foo', path: 'bar/index', extension: 'html', params: { 'foo' => 'bar', 'bar' => 'baz' } }.each do |key, value|
      it "sets #{key} to #{value}" do
        Kul::RequestContext.should_receive(:new).with(hash_containing(key => value))
        get request_string
      end
    end
  end

  context 'request for a controller route' do
    request_string = '/foo/bar/baz?foo=bar&bar=baz'
    { app: 'foo', controller: 'bar', action: 'baz', params: { 'foo' => 'bar', 'bar' => 'baz' } }.each do |key, value|
      it "sets #{key} to #{value}" do
        Kul::RequestContext.should_receive(:new).with(hash_containing(key => value))
        get request_string
      end
    end
  end

  context 'request for a controller route with an extension' do
    request_string = '/foo/bar/baz.html?foo=bar&bar=baz'
    { app: 'foo', controller: 'bar', action: 'baz', extension: 'html', params: { 'foo' => 'bar', 'bar' => 'baz' } }.each do |key, value|
      it "sets #{key} to #{value}" do
        Kul::RequestContext.should_receive(:new).with(hash_containing(key => value))
        get request_string
      end
    end
  end

  context 'request for a folder path' do
    request_string = '/foo/bar/baz/bat?foo=bar&bar=baz'
    { app: 'foo', path: 'bar/baz/bat/index', extension: 'html', params: { 'foo' => 'bar', 'bar' => 'baz' } }.each do |key, value|
      it "sets #{key} to #{value}" do
        Kul::RequestContext.should_receive(:new).with(hash_containing(key => value))
        get request_string
      end
    end
  end

  context 'request for a deep file path' do
    request_string = '/foo/bar/baz/bat.html?foo=bar&bar=baz'
    { app: 'foo', path: 'bar/baz/bat', extension: 'html', params: { 'foo' => 'bar', 'bar' => 'baz' } }.each do |key, value|
      it "sets #{key} to #{value}" do
        Kul::RequestContext.should_receive(:new).with(hash_containing(key => value))
        get request_string
      end
    end
  end

end