require 'spec_helper'

describe Kul::RequestContext do

  describe '#route' do
    it 'returns 404 if the extension is not supported' do
      request = Kul::RequestContext.new(path: 'bar/test.rb', verb: :GET)
      request.route_to_file.should be_a ResponseNotFound
    end
    it 'returns template render if the template exists' do
      inside_test_server do
        request = Kul::RequestContext.new(path: 'foo/context_test.html', verb: :GET)
        request.route_to_file.should be_a ResponseRenderTemplate
      end
    end
    it 'returns file render if the file exists' do
      inside_test_server do
        request = Kul::RequestContext.new(path: 'index.html', verb: :GET)
        request.route_to_file.should be_a ResponseRenderFile
      end
    end
  end

  describe '#handle' do
    it 'renders a folder path index.html' do
      inside_test_server do
        request = Kul::RequestContext.new(path: '', verb: :GET)
        request.route_to_file.should be_a ResponseRenderFile
        request.route_to_file.file.should == 'index.html'
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
