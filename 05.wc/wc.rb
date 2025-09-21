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

def main(**options)
  opt = options
  if ARGV.empty?
    print_standard(**opt)
  else
    all = { lines: 0, words: 0, capacity: 0 }
    paths = ARGV
    paths.each do |path|
      load_contents = Array.new(0)
      contents = File.read(path)
      contents.split(' ').each_with_index { |word, index| load_contents[index] = word }
      print_wc_details(contents.count("\n"), load_contents.size, File.size(path), **opt)
      print "#{path}\n"
      all[:lines] += contents.count("\n")
      all[:words] += load_contents.size
      all[:capacity] += File.size(path)
    end
    return unless paths.size != 1

    print_wc_details(all[:lines], all[:words], all[:capacity], **opt)
    print 'total'
  end
end

def print_wc_details(lines, words, capacity, **opt)
  if opt == {}
    print [
      lines,
      words,
      capacity,
      ''
    ].join(' ')
  else
    print "#{lines} " if opt[:l]
    print "#{words} " if opt[:w]
    print "#{capacity} " if opt[:c]
  end
end

def print_standard(**options)
  opt = options
  line_break = 0
  byte = 0
  while (path = $stdin.gets)
    line_break += 1
    byte += path.bytesize
    ARGV << path.chomp.split(' ')
  end
  print_wc_details(line_break, ARGV.flatten.size, byte, **opt)
end


main(**option)
