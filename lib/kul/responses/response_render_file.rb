class ResponseRenderFile < Kul::Response
  include HashInitialize

  attr_accessor :file

  def initialize(processor, opts = {})
    initialize_values opts
    @processor = processor
  end

  def render
    @processor.send_file @file
  end

end