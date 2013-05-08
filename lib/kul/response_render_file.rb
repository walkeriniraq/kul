require 'kul/response'
require 'kul/hash_initialize'

class ResponseRenderFile < Kul::Response
  include HashInitialize

  attr_accessor :file

  def render
    File.read(@file)
  end

end