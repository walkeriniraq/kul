class Kul::ServerSettings

  attr_accessor :served_file_extensions, :enable_sessions, :server_mode

  def initialize
    @served_file_extensions = %w(html js css)
    @enable_sessions = false
    @server_mode = :development
  end

end