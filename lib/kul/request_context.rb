require 'kul/hash_initialize'

class Kul::RequestContext
  include HashInitialize

  attr_reader :server, :app, :params

  def render_template(filename)
    ResponseRenderTemplate.new file: filename, context: self
  end
end