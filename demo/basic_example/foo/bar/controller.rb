module Foo
  module Bar
    def test
      'This is my test'
    end

    def test_render
      @thing = 'this is a cool thing!'
      @other_thing = 'this is another cool thing!'
      render_template 'foo/bar/test.html.erb'
    end
  end
end