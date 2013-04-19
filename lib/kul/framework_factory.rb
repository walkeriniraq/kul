require 'pathname'
require 'kul/base_server'
require 'kul/base_app'

class Kul::FrameworkFactory

  #14 - Better class reloading - ?
  #13 - settings accessor

  def self.create_server
    self.new.create_server
  end

  def self.create_app(app_name)
    self.new.create_app(app_name)
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

  def self.find_module(app_name, controller_name)
    self.new.find_module app_name, controller_name
  end

  def find_module(app_name, controller_name)
    controller_file = Pathname.new(Dir.getwd).join("#{app_name}/#{ controller_name }/controller.rb")
    return unless controller_file.exist?
    load(controller_file.to_s)
    return unless Module.const_defined? app_name.classify
    parent_module = Module.const_get app_name.classify
    return unless parent_module.const_defined? controller_name.classify
    parent_module.const_get controller_name.classify
  end

end