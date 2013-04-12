require 'pathname'
require 'kul/base_controller'
require 'kul/base_server'
require 'kul/base_app'

class Kul::FrameworkFactory

  def self.create_server
    self.new.create_server
  end

  def self.create_app(app_name)
    self.new.create_app(app_name)
  end

  def self.create_controller(app_name, controller_name)
    self.new.create_controller(app_name, controller_name)
  end

  def create_server
    load './server.rb' if File.exists? 'server.rb'
    return Object.const_get('Server'.classify).new if Object.const_defined? 'Server'.classify
    Kul::BaseServer.new
  end

  def create_app(app_name)
    app_file = Pathname.new(Dir.getwd).join("#{app_name}/#{app_name}_app.rb")
    load(app_file.to_s) if app_file.exist?
    app_class = "#{app_name}_app".classify
    return Object.const_get(app_class).new if Object.const_defined? app_class
    Kul::BaseApp.new
  end

  def create_controller(app_name, controller_name)
    controller_file = Pathname.new(Dir.getwd).join("#{app_name}/#{ controller_name }/#{ controller_name }_controller.rb")
    load(controller_file.to_s) if controller_file.exist?
    controller_class = "#{ controller_name }_controller".classify
    return Object.const_get(controller_class).new if Object.const_defined? controller_class
  end

end