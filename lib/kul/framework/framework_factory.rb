class Kul::FrameworkFactory

  def self.create_server
    self.new.create_server
  end

  def create_server
    load './server.rb' if File.exists? 'server.rb'
    return Object.const_get('Server'.classify).new if Object.const_defined? 'Server'.classify
    Kul::BaseServer.new
  end

  def self.get_app(app_name)
    self.new.create_app(app_name)
  end

  def create_app(app_name)
    app_file = Pathname.new(Dir.getwd).join("#{app_name}/#{app_name}_app.rb")
    load(app_file.to_s) if app_file.exist?
    app_class = "#{app_name}_app".classify
    return Object.const_get(app_class).new if Object.const_defined? app_class
    Kul::BaseApp.new
  end

  #def self.get_controller(app_name, controller_name)
  #  self.new.find_module app_name, controller_name
  #end

  def self.get_controller(path)
    self.new.find_module path.app_name, path.controller_name
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

  def self.get_route_type_list
    Kul::RouteTypeList.new
  end

  def self.create_request(options)
    Kul::RequestContext.new options
  end

end