require File.join(File.dirname(__FILE__), '..', 'lib', 'kul.rb')
Dir.chdir File.join(File.dirname(__FILE__), 'test_files')

require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'rspec'

set :environment, :test

#RSpec.configure do |config|
  #config.before(:each) { DataMapper.auto_migrate! }
#end