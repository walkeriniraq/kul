require 'kul/response'
require 'kul/hash_initialize'

class ResponseRenderTemplate < Kul::Response
  include HashInitialize

  attr_accessor :file, :context

  def render
    return Tilt.new(file).render(context)
  end

end