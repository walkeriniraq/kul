require 'spec_helper'

describe Kul::RouteListing do
  describe '#routes_from_file' do
    it 'returns filename for an .html file' do
      test = Kul::RouteListing.new.routes_from_file 'test.html'
      test.should include 'test.html'
      test.length.should == 1
    end
    it 'returns filename for an .css file' do
      test = Kul::RouteListing.new.routes_from_file 'test.css'
      test.should include 'test.css'
      test.length.should == 1
    end
    it 'returns filename for an .js file' do
      test = Kul::RouteListing.new.routes_from_file 'test.js'
      test.should include 'test.js'
      test.length.should == 1
    end
    it 'returns filename without .erb for an .html.erb file' do
      test = Kul::RouteListing.new.routes_from_file 'foo/bar/action.html.erb'
      test.should include 'foo/bar/action.html'
      test.length.should == 1
    end
    it 'returns filename without .scss for a .css.scss file' do
      test = Kul::RouteListing.new.routes_from_file 'css/test_sass.css.scss'
      test.should include 'css/test_sass.css'
      test.length.should == 1
    end
    it 'returns filename without .coffee for a .js.coffee file' do
      test = Kul::RouteListing.new.routes_from_file 'js/test_coffee.js.coffee'
      test.should include 'js/test_coffee.js'
      test.length.should == 1
    end
    it 'returns [] for a .rb file' do
      test = Kul::RouteListing.new.routes_from_file 'server.rb'
      test.should be_empty
    end
    it 'includes both / and /index.html for an index.html file' do
      test = Kul::RouteListing.new.routes_from_file 'index.html'
      test.should include '.'
      test.should include 'index.html'
    end
    it 'includes both /foo and /foo/index.html' do
      test = Kul::RouteListing.new.routes_from_file 'foo/index.html'
      test.should include 'foo'
      test.should include 'foo/index.html'
    end
  end
  describe '#list_routes_in_path' do
    it 'returns the actions from the controller' do
      inside_test_server do
        require './foo/bar/controller.rb'
        test = Kul::RouteListing.new.list_routes_in_path Pathname.new('foo/bar')
        test.should include 'foo/bar/test_action'
        test.should include 'foo/bar/repeat_action'
        test.should include 'foo/bar/post_action'
      end
    end
  end

  describe '#list_routes' do

  end
end