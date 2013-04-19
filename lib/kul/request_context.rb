require 'kul\hash_initialize'

class Kul::RequestContext
  include HashInitialize

  attr_reader :server, :app, :params
end