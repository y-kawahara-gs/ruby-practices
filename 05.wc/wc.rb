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
  wc_details = get_wc_details(content)
  puts remake_by_options(wc_details, options).join(' ')
end

def print_argument(options)
  paths = ARGV
  label = %w[line words bytes path]
  wc_rows = paths.map do |path|
    content = File.read(path)
    temporary_details = get_wc_details(content)
    temporary_details << path
    [label, temporary_details].transpose.to_h
  end

  if paths.size > 1
    total_hash = {
      'line' => calculation_total(wc_rows, 'line'),
      'words' => calculation_total(wc_rows, 'words'),
      'bytes' => calculation_total(wc_rows, 'bytes'),
      'total' => 'total'
    }
  end
  wc_rows << total_hash
  all_wc_rows = wc_rows.map(&:values)
  print_adjusted_wc(all_wc_rows, options)
end

def calculation_total(wc_rows, key)
  wc_rows.each.sum do |wc_hash|
    wc_hash[key]
  end
end

def get_wc_details(content)
  words = content.split(' ')
  [content.count("\n"), words.size, content.bytesize]
end

def print_adjusted_wc(wc_rows, options)
  temporary_details = wc_rows.map { |row| row.map(&:to_s) }
  vertical_details = temporary_details.transpose
  vertical_details = remake_by_options(vertical_details, options)

  widths = vertical_details.map do |vertical_values|
    vertical_values.map(&:length).max
  end

  vertical_details.transpose.each do |row|
    columns = row.map.with_index do |column, i|
      column.rjust(widths[i])
    end
    puts columns.join(' ')
  end
end

def remake_by_options(wc_rows, options)
  wc_details = []
  wc_details << wc_rows[0] if options[:l] || options.empty?
  wc_details << wc_rows[1] if options[:w] || options.empty?
  wc_details << wc_rows[2] if options[:c] || options.empty?
  wc_details << wc_rows[3]
  wc_details
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
