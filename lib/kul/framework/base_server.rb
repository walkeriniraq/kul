class Kul::BaseServer
  include Kul::Filter

  attr_accessor :before_filters, :after_filters, :around_filters

  def load_models
    Kul::FrameworkFactory.load_models()
  end

end
