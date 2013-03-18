require File.join(File.dirname(__FILE__), '..', 'lib', 'kul.rb')

require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'rspec'
require 'test_app_helper'

set :environment, :test

RSpec.configure do |config|
  config.include TestAppHelper
end