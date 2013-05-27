class ResponseText < Kul::Response
  include HashInitialize

  attr_accessor :text

  def content_type
    'text/plain'
  end

  def render
    text
  end

end