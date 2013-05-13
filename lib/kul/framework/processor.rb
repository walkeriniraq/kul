# this class handles the sinatra request and builds the request context
class Kul::Processor < Sinatra::Base
  set :extension_includes, %w(html js css)

  get '/favicon.ico' do
    send_file 'favicon.ico'
  end

  get '/*' do |path|
    request = Kul::FrameworkFactory.create_request path: path, params: params, processor: self, verb: :GET
    response = request.handle
    return response.render if response.respond_to? :render
    response.to_s
  end

end

