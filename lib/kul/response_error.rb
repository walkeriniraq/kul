require 'kul/response'
require 'kul/hash_initialize'

class ResponseError < Kul::Response
  include HashInitialize

  attr_accessor :message

  def render
    raise message
  end
end