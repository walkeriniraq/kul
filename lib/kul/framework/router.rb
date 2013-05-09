class Kul::Router

  def initialize
    @extensions = {
        'html' => [
            {extension: '.erb', instruction: :template},
            {instruction: :file}
        ],
        'js' => [
            {extension: '.coffee', instruction: :template},
            {instruction: :file}
        ],
        'css' => [
            {extension: '.scss', instruction: :template},
            {extension: '.sass', instruction: :template},
            {instruction: :file}
        ]
    }
  end

  def handle_extension?(extension)
    @extensions.keys.each { |key| return true if extension.end_with? key }
    false
  end

  def routing(extension)
    @extensions.find { |key, value| return value if extension.end_with? key }
  end

end