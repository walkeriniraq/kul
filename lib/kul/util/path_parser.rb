module Kul::PathParser
  APP_REGEX = %r|^\w*[/\?]|
  CONTROLLER_REGEX = %r|\w*/\w*[/\?]|

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
      name = @path[CONTROLLER_REGEX].andand[0..-2].andand.split('/').andand.at(1)
      @controller_name = { value: name }
    end
    @controller_name[:value]
  end

  def extension
    return 'html' unless @path.include? '.'
    @path.split('.').last.split('?').first
  end

  def action_name
    if @action_name.nil?
      @action_name = { value: get_action_name }
    end
    @action_name[:value]
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

  def get_action_name
    parts = @path.split('/')
    return if parts.count != 3
    parts = parts[2].split('?')
    return if parts[0].empty?
    parts[0]
  end

end