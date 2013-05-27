class ResponseRenderTemplate < Kul::Response
  include HashInitialize

  attr_accessor :file, :context

  def content_type
    context.extension
  end

  def render
    Tilt.new(file).render(context)
  end

end