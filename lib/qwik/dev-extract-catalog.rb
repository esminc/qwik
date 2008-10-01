#! /usr/bin/ruby
# Copyright (C) 2003-2008 AIST, All rights reserved.
# This is free software with ABSOLUTELY NO WARRANTY.
# You can redistribute it and/or modify it under the terms of the GNU GPL 2.

require 'pathname'
require 'pp'
require 'stringio'
$KCODE = 'SJIS'

class String
  def trim_line!
    self.chomp!
    self.gsub!(/\A\s*/, '')
    self.gsub!(/\s*\z/, '')
  end

  def strip_metachar!
    self.gsub!(/\\n/, '')
    self.gsub!(/\\"/, '"')
    self.sub!(/\A['"]/, '')
    self.sub!(/['"]\Z/, '')
  end
end

def parse(path)
  str = path.read

  str2 = ''
  str.each_line {|line|
    line.trim_line!

    next if line.empty?

    case line
    when /^#/, /^module /, /^class /, /^def /, /^\{/, /^\}/, /^end$/
      next
    end

    str2 << line
  }

  ar = []
  lines = str2.split(/','/)
  lines.each {|line|
    e, j = line.split(/['"]\s*=>\s*['"]/)
    ar << [e, j]
  }

  return ar
end

def main
  mypath = Pathname.new(__FILE__)
  catalog_ja = mypath.parent + 'catalog-ja.rb'
  catalog_ml_ja = mypath.parent + 'catalog-ml-ja.rb'

  ar = parse(catalog_ja)
  outpath = Pathname.new 'catalog-ja.txt'
  outpath.open('w') {|out|
    ar.each {|e, j|
      out.puts e
      out.puts j
      out.puts
    }
  }
end

main

exit

def parse_file(input_path)
  out = ''
  input_path.open("r").each_line do |line|
    line.trim_line!
    case line
    when /^#/, /^:charset/, /^:codeconv_method/
      next
    when /^(.+)\s*=>$/
      k = $1
      k.trim_line!
      k.strip_metachar!
      out << k+"\n"
    when /^(.+)\s*=>\s+(.+)\s*,$/
      k = $1
      k.trim_line!
      k.strip_metachar!
      v = $2
      v.trim_line!
      v.strip_metachar!
      out << k+"\n"
      out << v+"\n"
      out << "\n"
    when /^(.+)\s*,$/
      v = $1
      v.trim_line!
      v.strip_metachar!
      out << v+"\n"
      out << "\n"
    end
  end
  return out
end

def process(output_path, input_path)
  input_path = Pathname.new input_path
  out = parse_file(input_path)

  output_path = Pathname.new output_path
  output_path.open("w") do |output|
    output.print out
  end
end

process("catalog-ja.txt", catalog_ja)
process("catalog-ml-ja.txt", catalog_ml_ja)
