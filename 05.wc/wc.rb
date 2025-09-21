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
      contents = []
      content = File.read(path)
      content.split(' ').each_with_index { |word, index| contents[index] = word }
      lines, words, capacity = [content.count("\n"), contents.size, File.size(path)]
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
  if option == {}
    print [
      lines,
      words,
      capacity,
      ''
    ].join(' ')
  else
    print "#{lines} " if option[:l]
    print "#{words} " if option[:w]
    print "#{capacity} " if option[:c]
  end
end

def print_standard(option)
  line_break = 0
  byte = 0
  while (path = $stdin.gets)
    line_break += 1
    byte += path.bytesize
    ARGV << path.chomp.split(' ')
  end
  print_wc_details(line_break, ARGV.flatten.size, byte, option)
end

main(**option)
