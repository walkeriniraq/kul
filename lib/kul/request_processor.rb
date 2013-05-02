require 'kul/framework_factory'
require 'kul/route_listing'
require 'sass'

class Kul::RequestProcessor < Sinatra::Base
  # TODO:  break this up into two classes - one that encapsulates the request into a RequestContext, and
  # one that actually routes the request properly
  set :extension_includes, ['html', 'js', 'css']

  get '/favicon.ico' do
    send_file "favicon.ico"
  end

  get '/*.:extension' do
    try_render params[:splat].first, params[:extension] or ResponseNotFound.new.render
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

