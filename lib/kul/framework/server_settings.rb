class Kul::ServerSettings

  attr_accessor :served_file_extensions, :enable_sessions, :server_mode, :server_list
  attr_reader :rack_protection

  def initialize
    @server_mode = ENV['RACK_ENV'] || :development
    @rack_protection = RackProtectionSettings.new
  end

  def set_options(sinatra)
    sinatra.enable :logging
    sinatra.enable :sessions if enable_sessions
    sinatra.set :extension_includes, served_file_extensions || %w(html js css)
    sinatra.set :server, server_list if server_list
    sinatra.set :environment, server_mode
    rack_protection.set_options(sinatra)
  end

  def production?
    server_mode == :production
  end

  def server_mode=(mode)
    @server_mode = mode.to_sym
  end

  class RackProtectionSettings
    attr_accessor :disable, :origin_whitelist

    def initialize
      @disable = false
    end

    def set_options(sinatra)
      sinatra.disable :protection and return if disable == true
      protection = {}
      protection[:except] = disable unless disable == false
      protection[:origin_whitelist] = origin_whitelist if origin_whitelist
      sinatra.set :protection, protection unless protection.empty?
    end

  end

end