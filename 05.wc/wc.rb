#! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def option
  options = {}
  opt = OptionParser.new
  opt.on('-l') { |v| options[:l] = v }
  opt.on('-w') { |v| options[:w] = v }
  opt.on('-c') { |v| options[:c] = v }
  opt.parse!(ARGV)
  options
end

def main(**option)
  if ARGV.empty?
    print_standard(option)
  else
    all = { lines: 0, words: 0, capacity: 0 }
    paths = ARGV
    paths.each do |path|
      content = File.read(path)
      lines, words, capacity = wc_details(content, path)
      print_wc_details(lines, words, capacity, option)
      print "#{path}\n"
      all[:lines] += lines
      all[:words] += words
      all[:capacity] += capacity
    end
    return if paths.size == 1

    print_wc_details(all[:lines], all[:words], all[:capacity], option)
    print 'total'
  end
end

def print_wc_details(lines, words, capacity, option)
  print "#{lines} " if option[:l] || option == {}
  print "#{words} " if option[:w] || option == {}
  print "#{capacity} " if option[:c] || option == {}
end

def print_standard(option)
  contents = ""
  while (path = $stdin.gets)
    contents += path
  end
  lines, words, capacity = wc_details(contents)
  print_wc_details(lines, words, capacity, option)
end

def wc_details(content, path = "")
  contents = []
  content.split(' ').each_with_index { |word, index| contents[index] = word }
  if File.exist?(path)
    capacity = File.size(path)
  else
    capacity = content.bytesize
  end
  return [content.count("\n"), contents.size, capacity]
end

main(**option)
