#! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  if File.pipe?($stdin)
    print_standard(load_options)
  else
    print_argument(load_options)
  end
end

def print_standard(options)
  content = ''
  while (line = $stdin.gets)
    content += line
  end
  wc_hash = {}
  wc_hash[''] = get_wc_details(content)
  wc_details = remake_by_options(wc_hash, options)
  puts wc_details[''].values.join(' ')
end

def print_argument(options)
  paths = ARGV
  wc_hash = {}
  paths.each_with_index do |path, index|
    content = File.read(path)
    temporary_details = get_wc_details(content)
    if wc_hash.key?(path)
      new_path = path + ' '*index
      wc_hash[new_path] = temporary_details
    else
      wc_hash[path] = temporary_details
    end
  end
  if paths.size > 1
    total_hash = {
      'total' => {
        'line' => calculation_total(wc_hash, 'line'),
        'words' => calculation_total(wc_hash, 'words'),
        'bytes' => calculation_total(wc_hash, 'bytes')
      }
    }
    all_wc_hash = wc_hash.merge(total_hash)
  else
    all_wc_hash = wc_hash
  end

  print_adjusted_wc(all_wc_hash, options)
end

def calculation_total(wc_hash, key)
  wc_cal = wc_hash.keys
  wc_cal.each.sum do |wc_path|
    wc_hash[wc_path][key]
  end
end

def get_wc_details(content)
  words = content.split(' ')
  {
    'line' => content.count("\n"),
    'words' => words.size,
    'bytes' => content.bytesize
  }
end

def print_adjusted_wc(all_wc_hash, options)
  wc_hash = remake_by_options(all_wc_hash, options)

  widths = {
    'line' => get_length(wc_hash, 'line'),
    'words' => get_length(wc_hash, 'words'),
    'bytes' => get_length(wc_hash, 'bytes')
  }

  keys = %w[line words bytes]

  resize(wc_hash, widths, *keys)

  wc_keys = wc_hash.keys
  wc_keys.each do |file|
    wc_values = wc_hash[file].values
    wc_values.delete("")
    puts [wc_values, file.strip].join(' ')
  end
end

def resize(wc_hash, widths, *keys)
  resize_hash = wc_hash
  keys.each do |key|
    resize_hash.each_value do |file|
      file[key] = file[key].to_s.rjust(widths[key])
    end
  end
end

def get_length(wc_hash, key)
  values = wc_hash.keys.map do |n|
    wc_hash[n][key]
  end
  max_widths = values.max_by { |value| value.to_s.length }
  max_widths.to_s.length
end

def remake_by_options(all_wc_hash, options)
  remaked_wc_hash = Hash.new { |hash, key| hash[key] = {} }
  all_wc_hash.each_key do |wc_hash|
    remaked_wc_hash[wc_hash]['line'] = all_wc_hash[wc_hash]['line'] if options[:l] || options.empty?
    remaked_wc_hash[wc_hash]['words'] = all_wc_hash[wc_hash]['words'] if options[:w] || options.empty?
    remaked_wc_hash[wc_hash]['bytes'] = all_wc_hash[wc_hash]['bytes'] if options[:c] || options.empty?
  end
  remaked_wc_hash
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
