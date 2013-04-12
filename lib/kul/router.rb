require 'kul/framework_factory'
require 'sass'

class Kul::Router < Sinatra::Base
  set :extensions, ['html', 'js', 'css']

  get '/favicon.ico' do
    send_file "favicon.ico"
  end

  get '/*.:extension' do
    try_render params[:splat].first, params[:extension] or not_found
  end

  get '/:app/:controller/:action' do
    Kul::FrameworkFactory.create_server.route_action params
  end

  get '/' do
    try_render 'index', 'html' or not_found
  end

  get '/*' do
    try_render "#{params[:splat].first.to_s}index", 'html'
    not_found
  end

  def try_render(file_path, extension)
    return unless settings.extensions.include? extension
    path = Pathname.new("#{file_path}.#{extension}")
    send_file path.to_s if path.exist?
    case extension
    when 'css'
      return Tilt.new("#{file_path}.css.scss").render if File.exists? "#{file_path}.css.scss"
    when 'js'
      return Tilt.new("#{file_path}.js.coffee").render if File.exists? "#{file_path}.js.coffee"
    when 'html'
      return Kul::FrameworkFactory.create_server.route_path file_path, params
    end
    nil
  end

end

