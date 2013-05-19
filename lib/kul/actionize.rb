module Kul::Actionize

  def list_actions
    @__actions__ ||= {}
  end

  def action_paths
    name = self.to_s.gsub('::', '/').downcase
    @__actions__.map { |k, _| "#{name}/#{k}" }
  end

  def action_exists?(action_name, verb)
    return false unless (@__actions__ ||= {}).include? action_name.to_sym
    (@__actions__[action_name.to_sym] ||= {}).include? verb
  end

  def get(action_name, options = {}, &block)
    add_action(:GET, action_name, options, &block)
  end

  def post(action_name, options = {}, &block)
    add_action(:POST, action_name, options, &block)
  end

  def delete(action_name, options = {}, &block)
    add_action(:DELETE, action_name, options, &block)
  end

  def put(action_name, options = {}, &block)
    add_action(:PUT, action_name, options, &block)
  end

  def head(action_name, options = {}, &block)
    add_action(:HEAD, action_name, options, &block)
  end

  def options(action_name, options = {}, &block)
    add_action(:OPTIONS, action_name, options, &block)
  end

  def get_action(action_name, verb)
    @__actions__[action_name.to_sym][verb][:method]
  end

  def execute_action(instance, action_name, verb)
    action_name = action_name.to_sym
    raise 'Action does not exist: #{action_name}' unless action_exists?(action_name, verb)
    instance.instance_eval &get_action(action_name, verb)
  end

  def add_action(verb, action_name, options, &block)
    @__actions__                     ||= {}
    @__actions__[action_name.to_sym] ||= {}
    @__actions__[action_name.to_sym][verb] = { options: options, method: block }
  end

end

class Module
  def actionize!
    extend Kul::Actionize
  end
end

