#!/usr/bin/ruby
require 'algorithm/diff'
if ARGV.length != 2
  puts "Usage: #{$0} file1 file2"
  exit 1
end
data = []
for i in 0..1 do
  File.open(ARGV[i], "r") { |f|
    data[i] = f.read
  }
end
diff = data[0].diff(data[1])
p diff
