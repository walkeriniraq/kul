require 'sinatra/base'
require 'coffee-script'

class String
  def classify
    return self.split('_').collect(&:capitalize).join
  end
end

module Kul
  def Kul.run!
    Kul::Router.run!
  end
end

require 'kul/base_controller'
require 'kul/server'
require 'kul/version'
require 'kul/router'
