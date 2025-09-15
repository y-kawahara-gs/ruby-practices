#! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  display(**option)
end

def option
  options = {}
  opt = OptionParser.new
  opt.on('-l') { |v| options[:l] = v }
  opt.on('-w') { |v| options[:w] = v }
  opt.on('-c') { |v| options[:c] = v }
  opt.parse!(ARGV)
  options
end

def display(**options)
  opt = options
  all = { lines: 0, words: 0, capacity: 0 }
  paths = wc_paths
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

def wc_paths
  paths = ARGV
  if ARGV == []
    while (path = $stdin.gets)
      paths << path.chomp.split(' ')
    end
    max_size = paths.map(&:size).max
    paths.map! { |it| it.values_at(0..max_size) }
    paths.transpose.flatten.compact
  else
    paths
  end
end

main
