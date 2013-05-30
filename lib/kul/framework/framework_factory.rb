class Kul::FrameworkFactory

  SERVER_SETTINGS_FILENAME = 'server_settings.rb'

  def self.get_server
    factory_instance.get_server
  end

  def self.get_app(app_name)
    factory_instance.get_app app_name
  end

  def self.get_controller(path)
    factory_instance.find_controller_module path.app_name, path.controller_name
  end

  def self.create_request(options)
    Kul::RequestContext.new options
  end

  # TODO: refactor this into settings
  def self.get_route_type_list
    Kul::RouteTypeList.new
  end

  def self.factory_instance
    @instance ||= Kul::FrameworkFactory.new
  end

  def self.load_models(path = '.')
    path = Pathname.new(path) + 'models'
    return unless path.exist? && path.directory?
    path.each_child(false) do |file|
      if file.extname == '.rb'
        file = path + file
        clazz = file.basename.to_s.rsub('.rb', '').classify
        factory_instance.load_class(clazz, file)
      end
    end
  end

  def self.get_server_settings
    return @server_settings unless @server_settings.nil?
    @server_settings ||= Kul::ServerSettings.new
    # TODO: change this to require for thread safety
    require SERVER_SETTINGS_FILENAME if File.exists? SERVER_SETTINGS_FILENAME
    @server_settings
  end

  def initialize
    @file_listing = {}
    @load_lock = Mutex.new
  end

  def load_class(clazz, path_to_file)
    path_to_file = Pathname.new(path_to_file) unless path_to_file.is_a?(Pathname)
    reload_symbols path_to_file, clazz
  end

  def get_server
    load_class :Server, 'server.rb'
    return Object.const_get(:Server).new if Object.const_defined? :Server
    Kul::BaseServer.new
  end

  def get_app(app_name)
    app_file = "#{app_name}/#{app_name}_app.rb"
    app_class = "#{app_name}_app".classify
    load_class app_class, app_file
    return Object.const_get(app_class).new if Object.const_defined? app_class
    Kul::BaseApp.new
  end

  def find_controller_module(app_name, controller_name)
    return if app_name.nil? || controller_name.nil?
    controller_file = Pathname.new("#{app_name}/#{controller_name}/controller.rb")
    app_name = app_name.classify
    controller_name = controller_name.classify
    reload_symbols controller_file, "#{app_name}::#{controller_name}"
    return unless Module.const_defined?(app_name) && Module.const_get(app_name).const_defined?(controller_name)
    Module.const_get(app_name).const_get controller_name
  end

  private

  def reload_symbols(path, *symbols)
    unless [:development, :test].include? Kul::FrameworkFactory.get_server_settings.server_mode
      require path.expand_path if path.exist?
      return :no_change
    end
    result = check_file(path)
    case result
      when :reload
        @load_lock.synchronize do
          symbols.each { |sym| remove_symbol(sym.to_s) }
          @file_listing[path.to_s] = path.mtime
          load path.expand_path
        end
      when :load
        @load_lock.synchronize do
          @file_listing[path.to_s] = path.mtime
          load path.expand_path
        end
      when :file_not_exist
        symbols.each { |sym| remove_symbol(sym.to_s) }
    end
    result
  end

  def remove_symbol(sym)
    parent = Object
    modules = sym.split('::')
    symbol = modules.slice!(-1)
    modules.each do |mod|
      return unless parent.const_defined? mod
      parent = parent.const_get mod
    end
    return unless parent.const_defined? symbol
    parent.send(:remove_const, symbol)
  end

  def check_file(path)
    if @file_listing.has_key? path.to_s
      return :file_not_exist unless path.exist?
      return :no_change if path.mtime == @file_listing[path.to_s]
      return :reload
    end
    return :file_not_exist unless path.exist?
    :load
  end

end