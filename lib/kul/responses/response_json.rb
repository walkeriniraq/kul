class ResponseJson < Kul::Response
  include HashInitialize

  attr_accessor :data

  def content_type
    'application/json'
  end

  def render
    data.to_json
  end

end