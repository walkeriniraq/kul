module Foo
  module Bar
    actionize!

    get 'test_action' do
      'this is a nifty test action'
    end

  end
end