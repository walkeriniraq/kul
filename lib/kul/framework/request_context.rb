require 'andand'

class Kul::RequestContext
  include HashInitialize
  include Kul::PathParser

  attr_reader :path, :params, :processor, :verb

  def controller
    if @controller.nil?
      @controller = { value: Kul::FrameworkFactory.find_module(app_name, controller_name) }
    end
    @controller[:value]
  end

  def app
    if @app.nil?
      @app = { value: Kul::FrameworkFactory.create_app(app_name) }
    end
    @app[:value]
  end

  def server
    if @server.nil?
      @server = { value: Kul::FrameworkFactory.create_server }
    end
    @server[:value]
  end

  def has_action?
    unless controller.nil?
      return controller.respond_to?(:action_exists?) && controller.action_exists?(action_name, @verb)
    end
    false
  end

  def handle
    # server static routing
    # server filtering
    # app filtering
    return render_action if has_action?
    route
  end

  def route
    puts "Kul: rendering path: #{file_path}"
    router = Kul::FrameworkFactory.create_router
    return ResponseNotFound.new unless router.handle_extension? extension
    router.routing(file_path, extension) do |instruction, render_path|
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

  def render_file(filename)
    ResponseRenderFile.new processor, file: filename
  end

  def render_template(filename)
    ResponseRenderTemplate.new processor: processor, file: filename, context: self
  end

  def render_action
    controller.execute_action(self, action_name, @verb)
  end

end