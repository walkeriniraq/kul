class Kul::BaseServer
  include Kul::Filters

  def request_handler(request)
    request.server = self
    app = Kul::FrameworkFactory.create_app(request.app)
    app.handle_request(request)
  end

end
