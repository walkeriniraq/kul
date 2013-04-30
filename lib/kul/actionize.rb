module Kul::Actionize

  def list_actions
    @__actions__ ||= {}
  end

  def action_exists?(action_name)
    (@__actions__ ||= {}).include? action_name.to_sym
  end

  def get(action_name, options = {}, &block)
    add_action(:GET, action_name, options, &block)
  end

  def post(action_name, options = {}, &block)
    add_action(:POST, action_name, options, &block)
  end

  def get_action(action_name)
    @__actions__[action_name.to_sym][:method]
  end

  def execute_action(instance, action_name)
    action_name = action_name.to_sym
    raise 'Action does not exist: #{action_name}' unless action_exists? action_name
    instance.instance_eval &get_action(action_name)
  end

  def add_action(verb, action_name, options, &block)
    @__actions__                     ||= {}
    @__actions__[action_name.to_sym] = { verb: verb, options: options, method: block }
  end

end

class Module
  def actionize!
    extend Kul::Actionize
  end
end

