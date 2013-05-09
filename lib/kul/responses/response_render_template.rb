class ResponseRenderTemplate < Kul::Response
  include HashInitialize

  attr_accessor :file, :context

  def render
    context.set_content_type
    Tilt.new(file).render(context)
  end

end