class Kul::BaseApp
  include Kul::Filter

  attr_accessor :before_filters, :after_filters, :around_filters

end