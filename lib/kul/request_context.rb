class Kul::RequestContext
  # TODO: convert this to a hash initializer - not sure if that will work with reader...
  #include HashInitialize

  def initialize(server, app, params)
    @server = server
    @app = app
    @params = params
  end

  attr_reader :server, :app, :params
end