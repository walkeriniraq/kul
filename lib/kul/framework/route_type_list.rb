class Kul::RouteTypeList

  def initialize
    @file_extensions = %w(png jpg jpeg gif)
    @extensions = {
        'html' => [
            {:extra_extension =>  '.erb', :instruction => :template},
            {:instruction => :file}
        ],
        'js' => [
            {:extra_extension =>  '.coffee', :instruction => :compile},
            {:instruction => :file}
        ],
        'css' => [
            {:extra_extension =>  '.scss', :instruction => :compile},
            {:extra_extension =>  '.sass', :instruction => :compile},
            {:instruction => :file}
        ]
    }
  end

  def add_route_type(extension, instruction)
    @extensions[extension] = [] unless @extensions.has_key? extension
    @extensions[extension] << instruction
  end

  def handle_type?(extension)
    return true if @file_extensions.include? extension
    @extensions.keys.each { |key| return true if extension.end_with? key }
    false
  end

  # TODO: add tests for this method
  def route_type_listing(route)
    yield :file, route.file_path if @file_extensions.include? route.extension
    return unless handle_type? route.extension
    @extensions[route.extension].each do |value|
      yield value[:instruction], "#{route.file_path}#{value[:extra_extension]}"
    end
  end

  def valid_types
    valid = {}
    @extensions.each { |k, v| v.each { |x| x.has_key?(:extra_extension) ? valid["#{k}#{x[:extra_extension]}"] = k : valid[k] = k }}
    valid
  end

end