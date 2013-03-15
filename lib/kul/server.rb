require 'pathname'

class Kul::Server < Sinatra::Base
  Tilt.register Tilt::ERBTemplate, 'html.erb'

  get '/lib/:filename.js' do
    CoffeeScript.compile File.read(File.join("lib", params[:filename] + ".coffee"))
  end

  get '/favicon.ico' do
    send_file "favicon.ico"
  end

  # TODO: Figure out how to do post
  get '/:app/:template' do
    app_path = Pathname.new(params[:app])
    unless app_path.directory?
      puts 'failed app'
      raise Sinatra::NotFound
    end
    load 'server.rb' if Pathname.new('server.rb').exist?
    app_file = app_path.join("#{ params[:app] }/#{ params[:app] }_app.rb")
    load(app_file.to_s) if app_file.exist?

  end

  get '/:app/:controller/:action' do
    # process route
    app_path = Pathname.new(params[:app])
    unless app_path.directory?
      puts 'failed app'
      raise Sinatra::NotFound
    end
    controller_path = app_path.join(params[:controller])
    unless controller_path.directory?
      puts 'failed controller'
      raise Sinatra::NotFound
    end

    load 'server.rb' if Pathname.new('server.rb').exist?
    app_file = app_path.join("#{ params[:app] }/#{ params[:app] }_app.rb")
    load(app_file.to_s) if app_file.exist?
    controller_file = app_path.join("#{ params[:controller] }/#{ params[:controller] }_controller.rb")
    load(controller_file.to_s) if controller_file.exist?

    controller_object = build_controller params[:controller]
    #controller_object.server =
    #controller_object.app =
    controller_object.params = params
    controller_object.do_action
    controller_object.do_render
  end

  def build_controller(controller_name)
    controller_class = "#{ controller_name }_controller".classify
    if Object.const_defined? controller_class
      controller_object = Object.const_get(controller_class).new
    else
      controller_object = Kul::BaseController.new
    end
  end

end
