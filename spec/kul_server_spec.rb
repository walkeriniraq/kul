require 'spec_helper'
require 'test_app_helper'
require 'pry'

describe Kul::Server do

  context '.create_controller' do
    it 'should create a controller' do
      inside_test_app do
        test = Kul::Server.new.create_controller 'foo', 'bar'
        test.should be
        test.should be_a(BarController)
      end
    end
  end

end