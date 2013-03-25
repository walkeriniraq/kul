require 'kul/server_connection'

class Kul::Router < Sinatra::Base

  get '/favicon.ico' do
    send_file "favicon.ico"
  end

  get '/*.html' do
    path = Pathname.new("#{params[:splat].first}.html")
    send_file path.to_s if path.exist?
    Kul::ServerConnection.route_to_server params[:splat].first, params
  end

  get '/:app/:controller/:action' do
    Kul::ServerConnection.route_controller params
  end
  #  #  # process route
  #  #  app_path = Pathname.new(params[:app])
  #  #  unless app_path.directory?
  #  #    puts 'failed app'
  #  #    raise Sinatra::NotFound
  #  #  end
  #  #  controller_path = app_path.join(params[:controller])
  #  #  unless controller_path.directory?
  #  #    puts 'failed controller'
  #  #    raise Sinatra::NotFound
  #  #  end
  #  #
  #  #  load 'server.rb' if Pathname.new('server.rb').exist?
  #  #  app_file = app_path.join("#{ params[:app] }/#{ params[:app] }_app.rb")
  #  #  load(app_file.to_s) if app_file.exist?
  #
  #  controller = create_controller params[:app], params[:controller]
  #  puts "Controller: #{controller.to_s}  Action: #{params[:action]}  Controller respond_to? #{controller.respond_to? params[:action]}"
  #  return controller.send(params[:action]) if controller.respond_to? params[:action]
  #  raise Sinatra::NotFound
  #
  #  #  #controller_object.server =
  #  #  #controller_object.app =
  #  #  controller_object.params = params
  #  #  controller_object.do_action
  #  #  controller_object.do_render
  #end

  #get '/lib/:filename.js' do
  #  CoffeeScript.compile File.read(File.join("lib", params[:filename] + ".coffee"))
  #end
  #
  ## TODO: Figure out how to do post
  #get '/:app/:template' do
  #  app_path = Pathname.new(params[:app])
  #  unless app_path.directory?
  #    puts 'failed app'
  #    raise Sinatra::NotFound
  #  end
  #  load 'server.rb' if Pathname.new('server.rb').exist?
  #  app_file = app_path.join("#{ params[:app] }/#{ params[:app] }_app.rb")
  #  load(app_file.to_s) if app_file.exist?
  #
  #end
  #


end