require 'andand'

class Kul::RequestContext
  include HashInitialize

  attr_reader :path, :params, :processor, :verb, :session

  def initialize(params = {})
    initialize_values(params)
    @route = Kul::Route.new(@verb, @path)
  end

  def handle
    server.load_models if server.respond_to? :load_models
    # server filtering
    # app filtering
    return render_action if @route.has_action?
    route_to_file
  end

  def server
    @route.server
  end

  def route_to_file
    route_type_list = Kul::FrameworkFactory.get_route_type_list
    return ResponseNotFound.new unless route_type_list.handle_type? @route.extension
    route_type_list.route_type_listing(@route) do |instruction, render_path|
      if Pathname.new(render_path).exist?
        case instruction
          when :file
            return render_file render_path
          when :template
            return render_template render_path
        end
      end
    end
    ResponseNotFound.new
  end

  def extension
    @route.extension
  end

  def render_file(filename)
    ResponseRenderFile.new processor: processor, file: filename
  end

  def render_template(filename)
    ResponseRenderTemplate.new file: filename, context: self
  end

  def render_json(hash)
    ResponseJson.new data: hash
  end

  def render_action
    @route.controller.execute_action(self, @route.action_name, @verb)
  end

end