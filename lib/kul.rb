require 'sinatra/base'
require 'coffee-script'

class String
  def classify
    return self.split('_').collect(&:capitalize).join
  end
end

module Kul
  def Kul.run!
    puts "Kul framework hanging out. Version: #{Kul::VERSION}"
    Kul::Processor.run!
  end
end

require 'pathname'

# these includes are here because Intellij does not handle them
# correctly when they are in the folders underneath this one.

#general includes
require 'kul/actionize'
require 'kul/cli'
require 'kul/route_listing'
require 'kul/version'
require 'kul/util/hash_initialize'
require 'kul/util/path_parser'

# response includes
require 'kul/responses/response'
require 'kul/responses/response_error'
require 'kul/responses/response_not_found'
require 'kul/responses/response_render_file'
require 'kul/responses/response_render_template'
require 'kul/responses/response_text'

# framework includes
require 'kul/framework/filter'
require 'kul/framework/base_app'
require 'kul/framework/base_server'
require 'kul/framework/framework_factory'
require 'kul/framework/processor'
require 'kul/framework/request_context'
require 'kul/framework/router'