require 'kul/server_factory'
require 'sass'

class Kul::Router < Sinatra::Base

  get '/favicon.ico' do
    send_file "favicon.ico"
  end

  get '/*.:extension' do
    try_render params[:splat].first, params[:extension] or not_found
  end

  get '/:app/:controller/:action' do
    Kul::ServerFactory.create_server.route_action params
  end

  get '/' do
    try_render 'index', 'html' or not_found
  end

  get '/*' do
    try_render "#{params[:splat].first.to_s}index", 'html'
    not_found
  end

  def try_render(file_path, extension)
    # TODO: get this from the server somehow?
    # there's gotta be a better way to do this
    route_extensions = ['html', 'js', 'css']

    return unless route_extensions.include? extension
    path = Pathname.new("#{file_path}.#{extension}")
    send_file path.to_s if path.exist?
    case extension
    when 'css'
      return Tilt.new("#{file_path}.css.scss").render if File.exists? "#{file_path}.css.scss"
    when 'js'
      return Tilt.new("#{file_path}.js.coffee").render if File.exists? "#{file_path}.js.coffee"
    when 'html'
      return Kul::ServerFactory.create_server.route_path file_path, params
    end
    nil
  end

  def send_text(text, type='html')
    file = Rack::File.new nil
    file.path = path
    result = file.serving env
    result[1].each { |k, v| headers[k] ||= v }
    halt result[0], result[2]
  rescue Errno::ENOENT
    not_found
  end

end

