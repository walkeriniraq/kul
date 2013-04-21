require 'thor'
require 'kul'

class Kul::CLI < Thor
  desc 'server', 'Starts the Kul application server in the current working directory'
  def server
    Kul.run!
  end
end