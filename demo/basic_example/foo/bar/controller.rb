module Foo
  module Bar
    actionize!

    get 'test' do
      'This is my test'
    end

    get 'test_render' do
      @thing = 'this is a cool thing!'
      @other_thing = 'this is another cool thing!'
      render_template 'foo/bar/test.html.erb'
    end

  end
end