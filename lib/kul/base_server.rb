require 'kul/framework_factory'
require 'kul/request_handler'

class Kul::BaseServer
  include Kul::RequestHandler

  @@request_handler = Proc.new do |request|
    app = Kul::FrameworkFactory.create_app(request[:app])
    app.handle_request(request)
  end

  def request_handler_method
    @@request_handler
  end

end
