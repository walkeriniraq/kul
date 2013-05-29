class Kul::ServerSettings

  attr_accessor :served_file_extensions, :enable_sessions, :server_mode, :disable_protection

  def initialize
    @served_file_extensions = %w(html js css)
    @enable_sessions = false
    @server_mode = :development
    @disable_protection = false
  end

end