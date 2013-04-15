require 'kul/response'

class ResponseNotFound < Kul::Response

  def render
    throw Sinatra::NotFound
  end
end