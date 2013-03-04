require 'sinatra/base'
require 'coffee-script'
require 'pathname'

class String
  def classify
    return self.split('_').collect(&:capitalize).join
  end
end

class KulServer < Sinatra::Base
  set :public_folder, File.dirname(__FILE__) + '/static'
  Tilt.register Tilt::ERBTemplate, 'html.erb'

  def herb(template, options={}, locals={})
    render "html.erb", template, options, locals
  end

  #get '/test' do
  #  send_file File.join(settings.public_folder, 'test-runner.html')
  #end

  get '/demo' do
    send_file File.join(settings.public_folder, 'demo.html')
  end

  get '/lib/:filename.js' do
    CoffeeScript.compile File.read(File.join("lib", params[:filename] + ".coffee"))
  end

  get '/favicon.ico' do
    send_file "favicon.ico"
  end

  def process_request
  end

  # TODO: Figure out how to do post

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
    if Pathname.new('server.rb').exist?
      require('server.rb')
    end
    if app_path.join('app.rb').exist?
      require app_path.join('app.rb').to_s
    end
    if controller_path.join('controller.rb').exist?
      require controller_path.join('controller.rb').to_s
    end
    if Object.const_defined? params[:controller].classify
      controller_object = Object.const_get(params[:controller].classify).new
      if controller_object.respond_to? params[:action]
        controller_object.send(params[:action])
        puts "template: #{ controller_path.join('bar.html.erb') }"
        Tilt.new(controller_path.join('bar.html.erb').to_s).render(controller_object)
      end
    else

    end
      # if no view specified, then render the default view
    #"params: " + params.to_s

    #controller.to_sym.new
    #route = params[:splat].first
    #if Pathname.new(route + '.rb').exist?
    #  eval(File.read(route + '.rb'))
    #  puts "Foo test: #{@foo}"
    #end
    #template = Dir.glob(params[:splat].first + '.html.*').first
    ##herb params[:splat].first.to_sym
    #Tilt.new(template).render(self)
  end

end

KulServer.run!