require 'coveralls'
Coveralls.wear!

require File.join(File.dirname(__FILE__), '..', 'lib', 'kul.rb')

require 'sinatra'
require 'rack/test'
require 'rspec'
require 'test_app_helper'

# require all of the rspec helpers
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}

set :environment, :test

RSpec.configure do |config|
  config.include TestAppHelper
end

# assume that the reason a test is pending is that it hasn't been implemented
module RSpec::Core::Pending
  alias_method :old_pending, :pending

  def pending(reason = nil)
    old_pending(reason || "Not yet implemented")
  end
end