require 'kul/hash_initialize'

class Kul::RequestContext
  include HashInitialize

  attr_accessor :server, :app, :params, :controller, :action

  def render_template(filename)
    ResponseRenderTemplate.new file: filename, context: self
  end
end