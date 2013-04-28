class Kul::RouteListing

  def initialize
    @valid_extensions = %w(html js css)
    @valid_process_extensions = %w(erb scss coffee)
    @blocked_folders = []
  end

  def list_routes(path = '.')
    path = Pathname.new(path)
    routes = path.children.reject { |c| c.directory? }.map { |x| file_routes x.to_s }.flatten.sort!
    routes += path.children.select { |c| c.directory? }.map { |x| list_routes x }
    routes
  end

  def file_routes(file)
    path = Pathname.new(file)
    routes = []
    return routes if is_blocked file
    extension = path.extname[1..-1]
    routes << path.dirname.to_s if path.basename.to_s == 'index.html' && @valid_extensions.include?(extension)
    routes << file if @valid_extensions.include? extension
    routes += file_routes(file.chomp path.extname) if @valid_process_extensions.include? extension
    routes
  end

  def is_blocked(file)
    @blocked_folders.any? { |x| file.start_with? x }
  end

  def block_folder(folder)
    @blocked_folders << "/#{folder}"
  end


end