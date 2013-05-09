require 'spec_helper'

describe ResponseRenderTemplate do
  context '#render' do
    it 'renders a template' do
      inside_test_server do
        context = double(:set_content_type => nil)
        response = ResponseRenderTemplate.new file: 'foo/bar/test_erb.html.erb', context: context
        test = response.render
        test.should == 'This is my test'
      end
    end

    it 'renders the context in the template' do
      class TestContext
        attr_accessor :test, :other_test
      end
      inside_test_server do
        context = TestContext.new
        context.test = 'foo'
        context.other_test = 'bar'
        context.should_receive(:set_content_type)
        response = ResponseRenderTemplate.new file: 'foo/context_test.html.erb', context: context
        test = response.render
        test.should == 'test: foo, other: bar'
      end
    end
  end
end
