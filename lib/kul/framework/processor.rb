# this class handles the sinatra request and builds the request context
class Kul::Processor < Sinatra::Base
  set :extension_includes, %w(html js css)

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
    request = Kul::FrameworkFactory.create_request path: path, params: params, processor: self, verb: verb
    response = request.handle
    return response.render if response.respond_to? :render
    response.to_s
  end

end

