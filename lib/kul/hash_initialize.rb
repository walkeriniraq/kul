module HashInitialize
  def initialize(opts)
    opts.each do |k, v|
      if respond_to? "#{k.to_s}="
        send "#{k.to_s}=", v
      else
        # TODO: replace this with some sort of logging
        puts "Invalid parameter passed to #{self.class.to_s} initialize: #{k.to_s}"
      end
    end
  end
end