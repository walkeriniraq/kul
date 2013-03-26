require "benchmark"

=begin

This code is taken from Paul Mucur's excellent article at http://mudge.name/2011/01/26/passing-blocks-in-ruby-without-block.html

I was curious if this had been fixed yet or if it wasn't true in jRuby, but it seems to be true that passing a block is
much slower than the alternative. It's only about 2X the speed on my machine, but that's still not good (jRuby 1.7.3)

=end

def speak_with_block(&block)
  block.call
end

def speak_with_yield
  yield
end

n = 1_000_000
Benchmark.bmbm do |x|
  x.report("&block") do
    n.times { speak_with_block { "ook" } }
  end
  x.report("yield") do
    n.times { speak_with_yield { "ook" } }
  end
end