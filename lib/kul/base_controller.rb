class Kul::BaseController

  attr_accessor :params

  def do_action
    send(params[:action]) if respond_to? params[:action]
  end

  def do_render
    #route = params[:splat].first
    #if Pathname.new(route + '.rb').exist?
    #  eval(File.read(route + '.rb'))
    #  puts "Foo test: #{@foo}"
    #end
    #template = Dir.glob(params[:splat].first + '.html.*').first
    ##herb params[:splat].first.to_sym
    #Tilt.new(template).render(self)
    view = @template || params[:action]
    Tilt.new("#{ params[:app] }/#{ params[:controller] }/#{ view }.html.erb").render(self)
  end

  def render(template=nil)
    @template = template || @action
  end
end