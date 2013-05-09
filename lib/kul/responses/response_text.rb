class ResponseText < Kul::Response
  include HashInitialize

  attr_accessor :text

  def render
    text
  end

end