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
  wc_hash_list = []
  wc_hash_list << wc_hash[:lines] if options[:l] || options.empty?
  wc_hash_list << wc_hash[:words] if options[:w] || options.empty?
  wc_hash_list << wc_hash[:bytes] if options[:c] || options.empty?
  puts wc_hash_list.join(' ')
end

def print_argument
  options = load_options
  paths = ARGV
  wc_hash_list = paths.map do |path|
    content = File.read(path)
    get_wc_hash(content, path)
  end
  wc_hash_list << build_total_hash(wc_hash_list) if paths.size > 1
  print_adjusted_wc(wc_hash_list, options)
end

def build_total_hash(wc_hash_list)
  {
    lines: wc_hash_list.sum { |wc_hash| wc_hash[:lines] },
    words: wc_hash_list.sum { |wc_hash| wc_hash[:words] },
    bytes: wc_hash_list.sum { |wc_hash| wc_hash[:bytes] },
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

def print_adjusted_wc(wc_hash_list, options)
  widths = {
    lines: get_length(wc_hash_list, :lines),
    words: get_length(wc_hash_list, :words),
    bytes: get_length(wc_hash_list, :bytes)
  }
  wc_list = wc_hash_list.map do |wc_hash|
    wc_values = []
    wc_values << wc_hash[:lines].to_s.rjust(widths[:lines]) if options[:l] || options.empty?
    wc_values << wc_hash[:words].to_s.rjust(widths[:words]) if options[:w] || options.empty?
    wc_values << wc_hash[:bytes].to_s.rjust(widths[:bytes]) if options[:c] || options.empty?
    wc_values << wc_hash[:path]
    wc_values
  end
  print_wc_list(wc_list)
end

def print_wc_list(wc_list)
  wc_list.each do |wc_rows|
    puts wc_rows.join(' ')
  end
end

def get_length(wc_hash_list, target)
  max_content = wc_hash_list.max_by do |wc_hash|
    wc_hash[target]
  end
  max_content[target].to_s.length
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
