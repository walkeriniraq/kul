require 'pathname'
require 'pry'

class Kul::Server
  Tilt.register Tilt::ERBTemplate, 'html.erb'

  def create_controller(app_name, controller_name)
    controller_file = Pathname.new(Dir.getwd).join("#{app_name}/#{ controller_name }/#{ controller_name }_controller.rb")
    load(controller_file.to_s) if controller_file.exist?
    controller_class = "#{ controller_name }_controller".classify
    return Object.const_get(controller_class).new if Object.const_defined? controller_class
    #raise Sinatra::NotFound
  end

end
