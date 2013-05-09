class ResponseError < Kul::Response
  include HashInitialize

  attr_accessor :message

  def render
    raise message
  end
end