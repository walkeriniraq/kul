class Kul::Path
  CONTROLLER_REGEX = %r|^\w*[/\?]|

  def initialize(path)
    @path = path.to_s
  end

  def controller_name
    if @controller_name.nil?
      @controller_name = { value: get_controller_name }
    end
    @controller_name[:value]
  end

  def action_name
    if @action_name.nil?
      @action_name = { value: get_action_name }
    end
    @action_name[:value]
  end

  def extension
    return 'html' unless @path.include? '.'
    @path.split('.').last.split('?').first
  end

  def file_path
    path = @path.split('?').first
    return 'index.html' if path.nil?
    unless path.include? '.'
      if path[-1] == '/'
        return "#{path}index.html"
      else
        return "#{path}/index.html"
      end
    end
    path
  end

  private

  def get_controller_name
    parts = @path.split('/')
    case parts.count
      when 2
        return parts[0]
      when 1
        parts = parts.last.split('?')
        return parts[0] unless parts[0].empty? || parts[0].include?('.')
    end
    nil
  end

  def get_action_name
    return nil if controller_name.nil?
    parts = @path.split('/')
    if parts.count == 2
        parts = parts.last.split('?')
        return parts[0] unless parts[0].empty? || parts[0].include?('.')
    end
    return 'index'
  end

end