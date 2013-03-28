class Kul::RequestContext

  def initialize(server, app, params)
    @server = server
    @app = app
    @params = params
  end

  attr_reader :server, :app, :params
end