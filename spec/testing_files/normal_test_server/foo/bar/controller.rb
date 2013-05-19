module Foo
  module Bar
    actionize!

    get 'test_action' do
      'this is a nifty test action'
    end

    get 'repeat_action' do
      puts "INSTANCE_VARIABLES: " + self.instance_variables.to_s
      "The test value passed was: #{@params['test']}"
    end

    post 'post_action' do
      puts "INSTANCE_VARIABLES: " + self.instance_variables.to_s
      "The test value passed was: #{@params['test']}"
    end

  end
end