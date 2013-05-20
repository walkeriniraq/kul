require 'thor'
require 'kul'
require 'kul/route_listing'

class Kul::CLI < Thor
  desc 'server', 'Starts the Kul application server in the current working directory'
  def server
    Kul.run!
  end

  desc 'routes', 'Lists all possible routes if the server were started in the current directory'
  def routes
    Kul::RouteListing.new.route_list
  end
end