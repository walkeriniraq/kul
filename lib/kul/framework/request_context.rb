class Kul::RequestContext
  include HashInitialize

  attr_accessor :processor, :server, :app, :params, :controller, :action, :path, :extension

  def render_template(filename)
    ResponseRenderTemplate.new file: filename, context: self
  end

  def set_content_type
    return if @processor.nil? || @extension.nil?
    @processor.content_type @extension
  end
end