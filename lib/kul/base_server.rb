require 'kul/framework_factory'
require 'kul/request_context'
require 'kul/response_not_found'
require 'kul/response_render_template'
require 'kul/response_text'
require 'kul/response_error'

class Kul::BaseServer

  def route_path(path, params)
    app = Kul::FrameworkFactory.create_app(find_app path)
    return Tilt.new("#{path}.html.erb").render(Kul::RequestContext.new(self, app, params)) if File.exists? "#{path}.html.erb"
    raise Sinatra::NotFound
  end

  def find_app(path)
    path.partition('/').first if path.include? '/'
  end

  def route_action(request)
    route_action_specific request, request[:params]['app'], request[:params]['controller'], request[:params]['action']
  end

  private

  def route_action_specific(request, app_name, controller_name, action_name)
    controller_module = Kul::FrameworkFactory.find_module(app_name, controller_name)
    unless controller_module.nil? or !controller_module.instance_methods.include? action_name.to_sym
      request.extend controller_module
      response = request.send action_name
      return ResponseError.new message: "Nil response back from app / controller / action: #{app_name} / #{controller_name} / #{action_name}" if response.nil?
      return response if response.is_a? Kul::Response
      return ResponseText.new text: response.to_s
    end
    path = "#{app_name}/#{controller_name}/#{action_name}"
    return ResponseRenderTemplate.new file: "#{path}.html.erb", context: request if File.exists? "#{path}.html.erb"
    ResponseNotFound.new
  end
end
