module Foo
  module Bar
    actionize!

    get 'test_action' do
      'this is a nifty test action'
    end

    get 'repeat_action' do
      "The test value passed was: #{@params['test']}"
    end

    post 'post_action' do
      "The test value passed was: #{@params['test']}"
    end

  end
end