require 'kul/framework_factory'
require 'kul/request_handler'

class Kul::BaseServer
  include Kul::RequestHandler

  def request_handler(request)
    request.server = self
    app = Kul::FrameworkFactory.create_app(request.app)
    app.handle_request(request)
  end

  #@@request_handler = method(:server_request_handler)

  #@@request_handler = Proc.new do |request|
  #  request.server = self
  #  app = Kul::FrameworkFactory.create_app(request[:app])
  #  app.handle_request(request)
  #end

  #def request_handler_method
  #  @@request_handler
  #end

end
