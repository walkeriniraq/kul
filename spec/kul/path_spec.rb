require 'spec_helper'

describe Kul::Path do

  context 'root path' do
    subject(:request) { Kul::Path.new('') }

    it '#app_name is nil' do
      request.app_name.should be_nil
    end
    it '#extension is html' do
      request.extension.should == 'html'
    end
    it '#controller_name is nil' do
      request.controller_name.should be_nil
    end
    it '#action_name is nil' do
      request.action_name.should be_nil
    end
  end
  
  context '#file_path' do
    it 'returns the file path' do
      Kul::Path.new('foo/test.html?bar=bat&foo=bar').file_path.should == 'foo/test.html'
    end
    it 'returns index.html for the root path' do
      Kul::Path.new('').file_path.should == 'index.html'
    end
    it 'returns foo/index.html for the foo path' do
      Kul::Path.new('foo').file_path.should == 'foo/index.html'
    end
    it 'returns foo/index.html for the foo/ path' do
      Kul::Path.new('foo/').file_path.should == 'foo/index.html'
    end
  end

  describe '#extension' do
    it 'returns the extension' do
      Kul::Path.new('foo/test.js').extension.should == 'js'
    end
    it 'returns the extension correctly when get params' do
      Kul::Path.new('foo/test.js?test=thing').extension.should == 'js'
    end
    it 'returns html for app paths' do
      Kul::Path.new('foo').extension.should == 'html'
    end
    it 'returns html for app paths with trailing slash' do
      Kul::Path.new('foo/').extension.should == 'html'
    end
    it 'returns only the last extension' do
      Kul::Path.new('foo/test-3.4.3.min.js').extension.should == 'js'
    end
  end

  describe '#app_name' do
    it 'returns the app name' do
      Kul::Path.new('foo/bar/baz?test=thing').app_name.should == 'foo'
    end
    it 'returns nil for root file' do
      Kul::Path.new('baz.html?test=thing').app_name.should be_nil
    end
    it 'returns app for app path' do
      Kul::Path.new('baz/?test=thing').app_name.should == 'baz'
    end
    it 'returns app for app path without ending slash' do
      Kul::Path.new('baz?test=thing').app_name.should == 'baz'
    end
    it 'should return the same string' do
      request = Kul::Path.new('foo/bar/baz?test=thing')
      test = request.app_name
      request.app_name.should be_equal test
    end
  end

  describe '#controller_name' do
    it 'returns the name' do
      Kul::Path.new('foo/bar/baz?test=thing').controller_name.should == 'bar'
    end
    it 'returns nil if no controller' do
      test = Kul::Path.new('foo?test=thing').controller_name
      test.should be_nil
    end
    it 'returns nil if app path' do
      test = Kul::Path.new('foo/bar.html?test=thing').controller_name
      test.should be_nil
    end
    it 'returns nil for app path ending in slash' do
      test = Kul::Path.new('foo/?test=thing').controller_name
      test.should be_nil
    end
    it 'returns name when it ends path with params' do
      test = Kul::Path.new('foo/bar?test=thing').controller_name
      test.should == 'bar'
    end
    it 'returns name when it ends path' do
      test = Kul::Path.new('foo/bar').controller_name
      test.should == 'bar'
    end
    it 'returns name when it ends path with slash' do
      test = Kul::Path.new('foo/bar/?test=thing').controller_name
      test.should == 'bar'
    end
    it 'should return the same string' do
      request = Kul::Path.new('foo/bar/baz?test=thing')
      test = request.controller_name
      test.should be_equal request.controller_name
    end
  end

  describe '#action_name' do
    it 'returns the name' do
      test = Kul::Path.new('foo/bar/baz?test=thing').action_name
      test.should == 'baz'
    end
    it 'returns index if no action' do
      test = Kul::Path.new('foo/bar?test=thing').action_name
      test.should == 'index'
    end
    it 'returns index with controller with trailing slash' do
      test = Kul::Path.new('foo/bar/?test=thing').action_name
      test.should == 'index'
    end
    it 'returns nil when the path is longer than an action' do
      test = Kul::Path.new('foo/bar/baz/more.html?test=thing').action_name
      test.should be_nil
    end
    it 'returns the name when there are no params' do
      test = Kul::Path.new('foo/bar/baz').action_name
      test.should == 'baz'
    end
    it 'should return the same string' do
      request = Kul::Path.new('foo/bar/baz?test=thing')
      test = request.action_name
      test.should be_equal request.action_name
    end
  end
  
end

