#!/usr/bin/ruby
require 'algorithm/diff'

[
  [ "Hello, World!", "Hello with you, World!" ],
  [ "foo bar baz", "foo rob baz", ],
  [ "foo bar baz", ">foo bar baz< "],
].each { |a,b|
  puts a,b
  d = a.diff(b)
  p d.diffs
  #p d.compact
}
  
  
  
