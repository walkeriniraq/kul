require 'sinatra/base'
require 'coffee-script'

module Kul
  def Kul.run!
    Server.run!
  end
end

class String
  def classify
    return self.split('_').collect(&:capitalize).join
  end
end

require 'kul/base_controller'
require 'kul/server'
require 'kul/version'
require 'kul/router'
