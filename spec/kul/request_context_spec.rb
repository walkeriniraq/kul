require 'spec_helper'

describe Kul::RequestContext do
  context '#render_template' do
    it 'renders the template with itself as the context' do
      context = Kul::RequestContext.new
      test = context.render_template 'foo'
      test.should be
      test.file.should == 'foo'
      test.context.should == context
    end
  end
end
