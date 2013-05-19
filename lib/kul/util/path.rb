class Kul::Path
  APP_REGEX = %r|^\w*[/\?]|
  CONTROLLER_REGEX = %r|\w*/\w*[/\?]|

  def initialize(path)
    @path = path.to_s
  end

  def app_name
    if @app_name.nil?
      name = @path[APP_REGEX]
      name = name[0..-2] unless name.nil?
      @app_name = { value: name }
    end
    @app_name[:value]
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
    test = @path.split('?').first
    return 'index.html' if test.nil?
    unless test.include? '.'
      if test[-1] == '/'
        return "#{test}index.html"
      else
        return "#{test}/index.html"
      end
    end
    test
  end

  private

  def get_controller_name
    parts = @path.split('/')
    case parts.count
      when 3
        return parts[1]
      when 2
        parts = parts.last.split('?')
        return parts[0] unless parts[0].empty? || parts[0].include?('.')
    end
    nil
  end

  def get_action_name
    return nil if controller_name.nil?
    parts = @path.split('/')
    if parts.count == 3
        parts = parts.last.split('?')
        return parts[0] unless parts[0].empty? || parts[0].include?('.')
    end
    return 'index'
  end

end