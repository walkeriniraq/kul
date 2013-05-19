class Kul::RouteListing

  def initialize
    @valid_extensions = Kul::FrameworkFactory.get_route_type_list.valid_types
  end

  def list_routes(path = '.')
    path = Pathname.new(path)
    routes = list_routes_in_path(path)
    routes += path.children.select { |c| c.directory? }.map { |x| list_routes x }
    routes
  end

  def list_routes_in_path(path)
    routes = path.children.reject { |c| c.directory? }.map { |x| routes_from_file x.to_s }.flatten.sort!
    kul_path = Kul::Path.new(path)
    controller = Kul::FrameworkFactory.get_controller(kul_path)
    routes += controller.action_paths unless controller.nil?
    routes
  end

  def routes_from_file(file)
    path = Pathname.new(file)
    routes = []
    routes << path.dirname.to_s if path.basename.to_s == 'index.html' if @valid_extensions.has_key?('html')
    if file.end_with? *@valid_extensions.keys
      routes << path_for(file)
    end
    routes
  end

  def path_for(file)
    @valid_extensions.each { |k, v| return file.rsub(k, v) if file.end_with? k }
  end

end