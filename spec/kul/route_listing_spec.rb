require 'spec_helper'

describe Kul::RouteListing do
  describe '#file_routes' do
    it 'returns filename for an .html file' do
      test = Kul::RouteListing.new.file_routes '/test.html'
      test.should include '/test.html'
      test.length.should == 1
    end
    it 'returns filename for an .css file' do
      test = Kul::RouteListing.new.file_routes '/test.css'
      test.should include '/test.css'
      test.length.should == 1
    end
    it 'returns filename for an .js file' do
      test = Kul::RouteListing.new.file_routes '/test.js'
      test.should include '/test.js'
      test.length.should == 1
    end
    it 'returns filename without .erb for an .html.erb file' do
      test = Kul::RouteListing.new.file_routes '/foo/bar/action.html.erb'
      test.should include '/foo/bar/action.html'
      test.length.should == 1
    end
    it 'returns filename without .scss for a .css.scss file' do
      test = Kul::RouteListing.new.file_routes '/css/test_sass.css.scss'
      test.should include '/css/test_sass.css'
      test.length.should == 1
    end
    it 'returns filename without .coffee for a .js.coffee file' do
      test = Kul::RouteListing.new.file_routes '/js/test_coffee.js.coffee'
      test.should include '/js/test_coffee.js'
      test.length.should == 1
    end
    it 'returns [] for a .rb file' do
      test = Kul::RouteListing.new.file_routes '/server.rb'
      test.should be_empty
    end
    it 'includes both / and /index.html for an index.html file' do
      test = Kul::RouteListing.new.file_routes '/index.html'
      test.should include '/'
      test.should include '/index.html'
    end
    context 'when there are blocked folders' do
      it 'returns [] when the path contains blocked folders' do
        validator = Kul::RouteListing.new
        validator.block_folder 'foo'
        test = validator.file_routes '/foo/index.html'
        test.should be_empty
      end
    end
    context 'given a controller with actions' do
      it 'returns the actions from the controller' do
        inside_test_server do
          require './foo/bar/controller.rb'
          pending
        end
      end
    end
  end
end