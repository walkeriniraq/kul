require 'kul/app'
require 'kul/server_factory'
require 'kul/request_context'

class Kul::Server

  def route_path(path, params)
    #app = Kul::ServerFactory.create_app(find_app path)
    app = Kul::ServerFactory.create_app('foo')
    return Tilt.new("#{path}.html.erb").render(Kul::RequestContext.new(self, app, params)) if File.exists? "#{path}.html.erb"
    raise Sinatra::NotFound
  end

  def find_app(path)
    path.partition('/').first if path.include? '/'
  end

  def route_action(params)
    controller = Kul::ServerFactory.create_controller(params['app'], params['controller'])
    return controller.process_action(params) if controller.respond_to? :process_action
    return controller.send(params['action'], params) if controller.respond_to? params['action']
    raise Sinatra::NotFound
  end

end
