require File.join(File.dirname(__FILE__), '..', 'lib', 'kul.rb')

require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'rspec'
require 'test_app_helper'

set :environment, :test

require 'coveralls'
Coveralls.wear!

RSpec.configure do |config|
  config.include TestAppHelper
end

# I prefer to assume that the reason a test is pending is that it hasn't been implemented
module RSpec::Core::Pending
  alias_method :old_pending, :pending

  def pending(reason = nil)
    old_pending(reason || "Not yet implemented")
  end
end