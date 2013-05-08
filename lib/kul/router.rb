class Kul::Router

  def handle_extension?(extension)
    true
  end

  def routing(extension)
    case extension
      when 'html'
        [{ extension: 'html', instruction: :file }]
    end
  end
end