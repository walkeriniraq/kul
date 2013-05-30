class Kul::ServerSettings

  attr_accessor :served_file_extensions, :enable_sessions, :server_mode, :disable_protection, :server_list

  def initialize
    @served_file_extensions = %w(html js css)
    @enable_sessions = false
    self.server_mode = ENV['RACK_ENV'] || :development
    @disable_protection = false
    @server_list = nil
  end

  def server_mode=(mode)
    @server_mode = mode.to_sym
  end

end