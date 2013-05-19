class Kul::Route < Kul::Path

  def initialize(verb, path)
    @verb = verb
    @path = path.to_s
    # server static routing
    # app static routing
  end

  def server
    if @server.nil?
      @server = { value: Kul::FrameworkFactory.create_server }
    end
    @server[:value]
  end

  def app
    if @app.nil?
      @app = { value: Kul::FrameworkFactory.get_app(app_name) }
    end
    @app[:value]
  end

  def controller
    if @controller.nil?
      @controller = { value: Kul::FrameworkFactory.get_controller(self) }
    end
    @controller[:value]
  end

  def has_action?
    unless controller.nil?
      return controller.respond_to?(:action_exists?) && controller.action_exists?(action_name, @verb)
    end
    false
  end

end