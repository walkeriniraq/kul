class ResponseRenderTemplate < Kul::Response
  include HashInitialize

  attr_accessor :file, :context, :processor

  def render
    processor.content_type context.extension
    Tilt.new(file).render(context)
  end

end