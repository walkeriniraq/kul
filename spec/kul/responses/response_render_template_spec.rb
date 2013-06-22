require 'spec_helper'

describe ResponseRenderTemplate do
  context '#render' do
    it 'renders a template' do
      inside_test_server do
        processor = double(:content_type => nil)
        response = ResponseRenderTemplate.new processor: processor, file: 'app/bar/test_erb.html.erb', context: Kul::RequestContext.new(path: 'bar/test_erb.html')
        test = response.render
        test.should == 'This is my test'
      end
    end

    it 'renders the context in the template' do
      class TestContext
        attr_accessor :test, :other_test, :extension
      end
      inside_test_server do
        processor = double(:content_type => nil)
        context = TestContext.new
        context.test = 'foo'
        context.other_test = 'bar'
        context.extension = 'html'
        response = ResponseRenderTemplate.new processor: processor, file: 'app/context_test.html.erb', context: context
        test = response.render
        test.should == 'test: foo, other: bar'
      end
    end
  end
end
