require 'kul/server_factory'
require 'sass'

class Kul::Router < Sinatra::Base

  get '/favicon.ico' do
    send_file "favicon.ico"
  end

  get '/*.html' do
    path = Pathname.new("#{params[:splat].first}.html")
    send_file path.to_s if path.exist?
    Kul::ServerFactory.create_server.route_path params[:splat].first, params
  end

  get '/*.js' do
    path = Pathname.new("#{params[:splat].first}.js")
    send_file path.to_s if path.exist?
    path = Pathname.new("#{params[:splat].first}.js.coffee")
    return CoffeeScript.compile File.read(path) if path.exist?
    raise Sinatra::NotFound
  end

  get '/*.css' do
    path = Pathname.new("#{params[:splat].first}.css")
    send_file path.to_s if path.exist?
    return Tilt.new("#{params[:splat].first}.css.scss").render if File.exists? "#{params[:splat].first}.css.scss"
    raise Sinatra::NotFound
  end

  get '/:app/:controller/:action' do
    Kul::ServerFactory.create_server.route_action params
  end
end