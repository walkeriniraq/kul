require 'kul/request_context'
require 'kul/framework_factory'
require 'sass'

# this class handles the sinatra request and builds the request context
class Kul::RequestProcessor < Sinatra::Base
  set :extension_includes, %w(html js css)

  get '/favicon.ico' do
    send_file 'favicon.ico'
  end

  get '/:app/:controller/:action.:extension' do
    Kul::RequestProcessor.do_route :app => params[:app], :controller => params[:controller], :action => params[:action], :extension => params[:extension], :params => params
  end

  get '/:app/:controller/:action' do
    Kul::RequestProcessor.do_route :app => params[:app], :controller => params[:controller], :action => params[:action], :params => params
  end

  get '/:app/*.:extension' do |app, path, extension|
    Kul::RequestProcessor.do_route :app => app, :path => path, :extension => extension, :params => params
  end

  get '/:path.:extension' do
    Kul::RequestProcessor.do_route :path => params[:path], :extension => params[:extension], :params => params
  end

  get '/' do
    Kul::RequestProcessor.do_route :path => 'index', :extension => 'html', :params => params
  end

  get '/:app' do
    Kul::RequestProcessor.do_route :app => params[:app], :path => 'index', :extension => 'html', :params => params
  end

  get '/:app/*' do |app, path|
    Kul::RequestProcessor.do_route :app => app, :path => "#{path}/index", :extension => 'html', :params => params
  end

  def self.do_route(context_params = {})
    context = Kul::RequestContext.new context_params
    response = Kul::FrameworkFactory.create_server.handle_request context
    return response.render if response.respond_to? :render
    response.to_s
  end

end

