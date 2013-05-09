require 'spec_helper'

describe Kul::Response do
  context '#render' do
    class TestResponse < Kul::Response
      include HashInitialize
      attr_accessor :status, :body, :headers
    end
    it 'returns [status code, body] if there are no headers' do
      test = TestResponse.new(status: 404, body: 'foo').render
      test.first.should == 404
      test.last.should == 'foo'
    end
  end
end