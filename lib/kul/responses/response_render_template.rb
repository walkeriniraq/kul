class ResponseRenderTemplate < Kul::Response
  include HashInitialize

  attr_accessor :file, :context

  def render
    context.processor.content_type context.extension
    Tilt.new(file).render(context)
  end

end