require 'spec_helper'

describe ResponseNotFound do
  context '#render' do
    it 'returns a 404 status code' do
      test = ResponseNotFound.new
      test.status.should == 404
    end

    it 'returns some html that describes a 404' do
      test = ResponseNotFound.new
      test.body.should include '<html>'
      test.body.should include '<body>'
      test.body.should include "I have no idea what you're asking for."
    end
  end
end