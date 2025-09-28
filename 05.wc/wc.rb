#! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  if File.pipe?($stdin)
    print_standard
  else
    print_argument
  end
end

def print_standard
  options = load_options
  content = ''
  while (line = $stdin.gets)
    content += line
  end
  wc_hash = get_wc_hash(content)
  wc_contents = []
  wc_contents << wc_hash[:lines] if options[:l] || options.empty?
  wc_contents << wc_hash[:words] if options[:w] || options.empty?
  wc_contents << wc_hash[:bytes] if options[:c] || options.empty?
  puts wc_contents.join(' ')
end

def print_argument
  options = load_options
  paths = ARGV
  wc_contents = []
  paths.each do |path|
    content = File.read(path)
    wc_contents <<  get_wc_hash(content, path)
  end
  wc_contents << make_total_hash(wc_contents) if paths.size > 1
  print_adjusted_wc(wc_contents, options)
end

def make_total_hash(wc_contents)
  {
    lines: wc_contents.map { |v| v[:lines] }.sum,
    words: wc_contents.map { |v| v[:words] }.sum,
    bytes: wc_contents.map { |v| v[:bytes] }.sum,
    path: 'total'
  }
end

def get_wc_hash(content, path = nil)
  {
    lines: content.count("\n"),
    words: content.split(' ').size,
    bytes: content.bytesize,
    path: path
  }
end

def print_adjusted_wc(wc_contents, options)
  widths = {
    lines: get_length(wc_contents, :lines),
    words: get_length(wc_contents, :words),
    bytes: get_length(wc_contents, :bytes)
  }

  wc_contents.each do |wc_hash|
    print wc_hash[:lines].to_s.rjust(widths[:lines]).ljust(widths[:lines] + 1) if options[:l] || options.empty?
    print wc_hash[:words].to_s.rjust(widths[:words]).ljust(widths[:lines] + 1) if options[:w] || options.empty?
    print wc_hash[:bytes].to_s.rjust(widths[:bytes]).ljust(widths[:bytes] + 1) if options[:c] || options.empty?
    puts wc_hash[:path]
  end
end

def get_length(wc_contents, symbol)
  max_content = wc_contents.max_by do |wc_hash|
    wc_hash[symbol]
  end
  max_content[symbol].to_s.length
end

def load_options
  options = {}
  opt = OptionParser.new
  opt.on('-l') { |v| options[:l] = v }
  opt.on('-w') { |v| options[:w] = v }
  opt.on('-c') { |v| options[:c] = v }
  opt.parse!(ARGV)
  options
end

main
