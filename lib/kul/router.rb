require 'kul/server_factory'
require 'sass'

class Kul::Router < Sinatra::Base

  get '/favicon.ico' do
    send_file "favicon.ico"
  end

  get '/*.:extension' do
    # TODO: get this from the server somehow?
    # there's gotta be a better way to do this
    route_extensions = ['html', 'js', 'css']

    raise Sinatra::NotFound unless route_extensions.include? params[:extension]
    path = Pathname.new("#{params[:splat].first}.#{params[:extension]}")
    send_file path.to_s if path.exist?
    case params[:extension]
    when 'css'
      return Tilt.new("#{params[:splat].first}.css.scss").render if File.exists? "#{params[:splat].first}.css.scss"
    when 'js'
      return Tilt.new("#{params[:splat].first}.js.coffee").render if File.exists? "#{params[:splat].first}.js.coffee"
    when 'html'
      return Kul::ServerFactory.create_server.route_path params[:splat].first, params
    end
    raise Sinatra::NotFound
  end

  get '/:app/:controller/:action' do
    Kul::ServerFactory.create_server.route_action params
  end
end

