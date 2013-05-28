class ResponseError < Kul::Response
  include HashInitialize

  attr_accessor :message

  def render
    [500, @message]
  end
end