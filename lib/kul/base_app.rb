require 'kul/framework_factory'
require 'kul/request_handler'

class Kul::BaseApp
  include Kul::RequestHandler

  def request_handler(request)
  end

  #def self.app_request_handler(request)
  #
  #end
  #
  #@@request_handler = method(:app_request_handler)
  #
  #def request_handler_method
  #  @@request_handler
  #end

  #def try_render(file_path, extension)
  #  return unless settings.extension_includes.include? extension
  #  path = Pathname.new("#{file_path}.#{extension}")
  #  send_file path.to_s if path.exist?
  #  return case extension
  #           when 'css'
  #             render_if "#{file_path}.css.scss"
  #           when 'js'
  #             render_if "#{file_path}.js.coffee"
  #           when 'html'
  #             Kul::FrameworkFactory.create_server.route_path file_path, params
  #         end
  #end
  #
  #def render_if(path)
  #  Tilt.new(path).render if File.exists? path
  #end

  #def route_path(path, params)
  #  app = Kul::FrameworkFactory.create_app(find_app path)
  #  return Tilt.new("#{path}.html.erb").render(Kul::RequestContext.new(server: self, app: app, params: params)) if File.exists? "#{path}.html.erb"
  #  raise Sinatra::NotFound
  #end
  #
  #def find_app(path)
  #  path.partition('/').first if path.include? '/'
  #end
  #
  #def route_action(request)
  #  route_action_specific request, request.params['app'], request.params['controller'], request.params['action']
  #end
  #
  #private
  #
  #def route_action_specific(request, app_name, controller_name, action_name)
  #  controller_module = Kul::FrameworkFactory.find_module(app_name, controller_name)
  #  unless controller_module.nil? or !controller_module.instance_methods.include? action_name.to_sym
  #    request.extend controller_module
  #    response = request.send action_name
  #    return ResponseError.new message: "Nil response back from app / controller / action: #{app_name} / #{controller_name} / #{action_name}" if response.nil?
  #    return response if response.is_a? Kul::Response
  #    return ResponseText.new text: response.to_s
  #  end
  #  path = "#{app_name}/#{controller_name}/#{action_name}"
  #  return ResponseRenderTemplate.new file: "#{path}.html.erb", context: request if File.exists? "#{path}.html.erb"
  #  ResponseNotFound.new
  #end

end