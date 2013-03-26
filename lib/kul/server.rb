require 'kul/app'
require 'kul/server_factory'

class Kul::Server

  def route_action(params)
    controller = Kul::ServerFactory.create_controller(params['app'], params['controller'])
    return controller.process_action(params) if controller.respond_to? :process_action
    return controller.send(params['action'], params) if controller.respond_to? params['action']
    raise Sinatra::NotFound
  end

end
