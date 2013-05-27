class ResponseRenderFile < Kul::Response
  include HashInitialize

  attr_accessor :file, :processor

  def render
    @processor.send_file @file
  end

end