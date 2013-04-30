require 'sinatra/base'
require 'coffee-script'

class String
  def classify
    return self.split('_').collect(&:capitalize).join
  end
end

module Kul
  def Kul.run!
    puts "Kul framework hanging out. Version: #{Kul::VERSION}"
    # TODO: figure out some way of getting the config and then set the routing options
    Kul::Router.run!
  end
end

require 'kul/router'
require 'kul/actionize'
require 'kul/version'