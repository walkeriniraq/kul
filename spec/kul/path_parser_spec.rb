require 'spec_helper'

describe Kul::PathParser do
  class PathParserTestClass
    include Kul::PathParser
    def initialize(path)
      @path = path
    end
  end

  context 'root path' do
    subject(:request) { PathParserTestClass.new('') }

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
      PathParserTestClass.new('foo/test.html?bar=bat&foo=bar').file_path.should == 'foo/test.html'
    end
    it 'returns index.html for the root path' do
      PathParserTestClass.new('').file_path.should == 'index.html'
    end
    it 'returns foo/index.html for the foo path' do
      PathParserTestClass.new('foo').file_path.should == 'foo/index.html'
    end
    it 'returns foo/index.html for the foo/ path' do
      PathParserTestClass.new('foo/').file_path.should == 'foo/index.html'
    end
  end

  describe '#extension' do
    it 'returns the extension' do
      PathParserTestClass.new('foo/test.js').extension.should == 'js'
    end
    it 'returns the extension correctly when get params' do
      PathParserTestClass.new('foo/test.js?test=thing').extension.should == 'js'
    end
    it 'returns html for app paths' do
      PathParserTestClass.new('foo').extension.should == 'html'
    end
    it 'returns html for app paths with trailing slash' do
      PathParserTestClass.new('foo/').extension.should == 'html'
    end
    it 'returns only the last extension' do
      PathParserTestClass.new('foo/test-3.4.3.min.js').extension.should == 'js'
    end
  end

  describe '#app_name' do
    it 'returns the app name' do
      PathParserTestClass.new('foo/bar/baz?test=thing').app_name.should == 'foo'
    end
    it 'returns nil for root file' do
      PathParserTestClass.new('baz.html?test=thing').app_name.should be_nil
    end
    it 'returns app for app path' do
      PathParserTestClass.new('baz/?test=thing').app_name.should == 'baz'
    end
    it 'returns app for app path without ending slash' do
      PathParserTestClass.new('baz?test=thing').app_name.should == 'baz'
    end
    it 'should return the same string' do
      request = PathParserTestClass.new('foo/bar/baz?test=thing')
      test = request.app_name
      request.app_name.should be_equal test
    end
  end

  describe '#controller_name' do
    it 'returns the name' do
      PathParserTestClass.new('foo/bar/baz?test=thing').controller_name.should == 'bar'
    end
    it 'returns nil if no controller' do
      test = PathParserTestClass.new('foo?test=thing').controller_name
      test.should be_nil
    end
    it 'returns nil if app path' do
      test = PathParserTestClass.new('foo/bar.html?test=thing').controller_name
      test.should be_nil
    end
    it 'returns nil for app path ending in slash' do
      test = PathParserTestClass.new('foo/?test=thing').controller_name
      test.should be_nil
    end
    it 'returns name when it ends path' do
      test = PathParserTestClass.new('foo/bar?test=thing').controller_name
      test.should == 'bar'
    end
    it 'returns name when it ends path with slash' do
      test = PathParserTestClass.new('foo/bar/?test=thing').controller_name
      test.should == 'bar'
    end
    it 'should return the same string' do
      request = PathParserTestClass.new('foo/bar/baz?test=thing')
      test = request.controller_name
      test.should be_equal request.controller_name
    end
  end

  describe '#action_name' do
    it 'returns the name' do
      test = PathParserTestClass.new('foo/bar/baz?test=thing').action_name
      test.should == 'baz'
    end
    it 'returns nil if no action' do
      test = PathParserTestClass.new('foo/bar?test=thing').action_name
      test.should be_nil
    end
    it 'returns nil with controller with trailing slash' do
      test = PathParserTestClass.new('foo/bar/?test=thing').action_name
      test.should be_nil
    end
    it 'returns nil when the path is longer than an action' do
      test = PathParserTestClass.new('foo/bar/baz/more.html?test=thing').action_name
      test.should be_nil
    end
    it 'returns the name when there are no params' do
      test = PathParserTestClass.new('foo/bar/baz').action_name
      test.should == 'baz'
    end
    it 'should return the same string' do
      request = PathParserTestClass.new('foo/bar/baz?test=thing')
      test = request.action_name
      test.should be_equal request.action_name
    end
  end


end