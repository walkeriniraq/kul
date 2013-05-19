require 'spec_helper'

describe Kul::RequestContext do

  describe '#server' do
    let(:request) { Kul::RequestContext.new(path: '') }
    it 'should return a server' do
      request.server.should be_a Kul::BaseServer
    end
    it 'should return the same server' do
      test = request.server
      test.should be_equal request.server
    end
  end

  describe '#app' do
    let(:request) { Kul::RequestContext.new(path: 'foo/bar/baz?test=thing') }
    it 'should return an app' do
      request.app.should be_a Kul::BaseApp
    end
    it 'should return the same app' do
      test = request.app
      test.should be_equal request.app
    end
  end

  describe '#controller' do
    let(:request) { Kul::RequestContext.new(path: 'foo/bar/baz?test=thing') }
    it 'should return a controller module' do
      inside_test_server do
        request.controller.should be_a Module
      end
    end
    it 'should return the correct module' do
      inside_test_server do
        request.controller.should == Foo::Bar
      end
    end
  end

  describe '#has_action?' do
    it 'should return true for a valid action' do
      inside_test_server do
        request = Kul::RequestContext.new(path: 'foo/bar/test_action?test=thing', verb: :GET)
        request.has_action?.should be_true
      end
    end
    it 'should return false if no action' do
      inside_test_server do
        request = Kul::RequestContext.new(path: 'foo/bar/test_action?test=thing', verb: :PUT)
        request.has_action?.should be_false
      end
    end
    it 'should return false if no controller module' do
      inside_test_server do
        request = Kul::RequestContext.new(path: 'foo/baz/test_action?test=thing', verb: :GET)
        request.has_action?.should be_false
      end
    end
    it 'should return false if not an actionize model' do
      module Bar
        module Baz
          def test_action
            'foo'
          end
        end
      end
      request = Kul::RequestContext.new(path: 'bar/baz/test_action?test=thing', verb: :GET)
      request.has_action?.should be_false
    end
  end

  describe '#route' do
    it 'returns 404 if the extension is not supported' do
      request = Kul::RequestContext.new(path: 'bar/test.rb', verb: :GET)
      request.route.should be_a ResponseNotFound
    end
    it 'returns template render if the template exists' do
      inside_test_server do
        request = Kul::RequestContext.new(path: 'foo/context_test.html', verb: :GET)
        request.route.should be_a ResponseRenderTemplate
      end
    end
    it 'returns file render if the file exists' do
      inside_test_server do
        request = Kul::RequestContext.new(path: 'index.html', verb: :GET)
        request.route.should be_a ResponseRenderFile
      end
    end
  end

  describe '#handle' do
    it 'renders a folder path index.html' do
      inside_test_server do
        request = Kul::RequestContext.new(path: '', verb: :GET)
        request.route.should be_a ResponseRenderFile
        request.route.file.should == 'index.html'
      end
    end
  end

  describe '#render_action' do
    it 'returns the response from the action' do
      inside_test_server do
        request = Kul::RequestContext.new(path: 'foo/bar/test_action', verb: :GET)
        request.render_action.should == 'this is a nifty test action'
      end
    end
    it 'passes the context to the action' do
      inside_test_server do
        request = Kul::RequestContext.new(path: 'foo/bar/repeat_action', verb: :GET, params: { 'test' => 'a thing'})
        request.render_action.should == 'The test value passed was: a thing'
      end
    end
    it 'handles POST verbs' do
      inside_test_server do
        request = Kul::RequestContext.new(path: 'foo/bar/post_action', verb: :POST, params: { 'test' => 'a thing'})
        request.render_action.should == 'The test value passed was: a thing'
      end
    end
  end

end
