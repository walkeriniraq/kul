require 'sinatra/base'
require 'coffee-script'

class String
  def classify
    split('_').collect(&:capitalize).join
  end

  def rsub(pattern, replacement)
    reverse.sub(pattern.reverse, replacement.reverse).reverse
  end
end

module Kul
  def Kul.run!
    puts "Kul framework hanging out. Version: #{Kul::VERSION}"
    Kul::Processor.run!
  end

  def self.settings
    Kul::FrameworkFactory.get_server_settings
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
require 'kul/util/path'

# response includes
require 'kul/responses/response'
require 'kul/responses/response_error'
require 'kul/responses/response_not_found'
require 'kul/responses/response_render_file'
require 'kul/responses/response_render_template'
require 'kul/responses/response_compiled_file'
require 'kul/responses/response_text'
require 'kul/responses/response_json'

# framework includes
require 'kul/framework/route'
require 'kul/framework/filter'
require 'kul/framework/base_app'
require 'kul/framework/base_server'
require 'kul/framework/server_settings'
require 'kul/framework/framework_factory'
require 'kul/framework/processor'
require 'kul/framework/request_context'
require 'kul/framework/route_type_list'