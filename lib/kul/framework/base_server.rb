class Kul::BaseServer < Kul::Filter

  def request_handler(request)
    request.server = self
    app = Kul::FrameworkFactory.create_app(request.app)
    app.filter_request(request)
  end

end
