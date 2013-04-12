require 'sinatra/base'
require 'coffee-script'

require 'kul/version'
require 'kul/router'

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
