require 'kul/response'
require 'kul/hash_initialize'

class ResponseText < Kul::Response
  include HashInitialize

  attr_accessor :text

  def render
    text
  end

end