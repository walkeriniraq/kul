# this class handles the sinatra request and builds the request context
class Kul::Processor < Sinatra::Base

  settings = Kul.settings
  set :extension_includes, settings.served_file_extensions
  enable :sessions if settings.enable_sessions

  get '/favicon.ico' do
    send_file 'favicon.ico'
  end

  get '/*' do |path|
    handle_action path, :GET
  end

  post '/*' do |path|
    handle_action path, :POST
  end

  put '/*' do |path|
    handle_action path, :PUT
  end

  delete '/*' do |path|
    handle_action path, :DELETE
  end

  def handle_action(path, verb)
    stuff = { path: path, params: params, processor: self, verb: verb }
    stuff[:session] = session if Kul.settings.enable_sessions
    request = Kul::FrameworkFactory.create_request stuff
    response = request.handle
    content_type response.content_type if response.respond_to? :content_type
    return response.render if response.respond_to? :render
    response.to_s
  rescue => e
    puts "Recieved error: #{e.to_s}"
    ResponseError.new(message: e.to_s).render
  end

end

