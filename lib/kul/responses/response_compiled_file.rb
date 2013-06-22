class ResponseCompiledFile < Kul::Response
  include HashInitialize

  attr_accessor :file, :processor, :request

  def content_type
    request.extension
  end

  def render
    temp_location = Pathname.new('temp') + request.route.file_path
    render_file = Pathname.new(file)
    render_file(render_file, temp_location)
    processor.send_file temp_location
  end

  def render_file(file_to_render, temp_location)
    return if temp_location.exist? && temp_location.mtime >= file_to_render.mtime
    temp_location.parent.mkpath
    content = Tilt.new(file_to_render.to_s).render
    File.open(temp_location, 'w') { |f| f.write(content) }

  end
end