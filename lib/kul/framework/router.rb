class Kul::Router

  def initialize
    @extensions = {
        'html' => [
            {:extra_extension =>  '.erb', :instruction => :template},
            {:instruction => :file}
        ],
        'js' => [
            {:extra_extension =>  '.coffee', :instruction => :template},
            {:instruction => :file}
        ],
        'css' => [
            {:extra_extension =>  '.scss', :instruction => :template},
            {:extra_extension =>  '.sass', :instruction => :template},
            {:instruction => :file}
        ]
    }
  end

  def handle_extension?(extension)
    @extensions.keys.each { |key| return true if extension.end_with? key }
    false
  end

  def routing(file_path, extension)
    return unless handle_extension? extension
    @extensions[extension].each do |value|
      yield value[:instruction], "#{file_path}#{value[:extra_extension]}"
    end
  end

end