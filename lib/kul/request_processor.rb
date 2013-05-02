require 'kul/framework_factory'
require 'kul/route_listing'
require 'sass'

# this class handles the sinatra request and builds the request context
class Kul::RequestProcessor < Sinatra::Base
  set :extension_includes, ['html', 'js', 'css']

  get '/favicon.ico' do
    send_file "favicon.ico"
  end

  get '/*.:extension' do
    puts params.to_s
    Kul::RequestContext.new :path => params[:splat].first, :extension => params[:extension], :params => params
  end

  get '/:app/:controller/:action' do
    Kul::FrameworkFactory.create_server.route_action(Kul::RequestContext.new(params: params)).render
  end

  get '/' do
    try_render 'index', 'html' or ResponseNotFound.new.render
  end

  get '/*' do
    try_render "#{params[:splat].first.to_s}/index", 'html' or ResponseNotFound.new.render
  end

  def try_render(file_path, extension)
    return unless settings.extension_includes.include? extension
    path = Pathname.new("#{file_path}.#{extension}")
    send_file path.to_s if path.exist?
    return case extension
             when 'css'
               render_if "#{file_path}.css.scss"
             when 'js'
               render_if "#{file_path}.js.coffee"
             when 'html'
               Kul::FrameworkFactory.create_server.route_path file_path, params
           end
  end

  def render_if(path)
    Tilt.new(path).render if File.exists? path
  end

end

