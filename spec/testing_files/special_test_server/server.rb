def some_random_function(foo)
  return foo.upcase if foo.method_defined? :upcase
  foo
end