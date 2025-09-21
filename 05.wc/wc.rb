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
    print_argument(option)
  end
end

def print_argument(option)
  paths = ARGV
  wc_rows = []
  counter = []
  paths.each_with_index do |path, index|
    content = File.read(path)
    wc_rows[index] = wc_details(option, content)
    wc_details(option, content).each_with_index do |point, i|
      counter[i] = (counter[i] || 0) + point
    end
    wc_rows[index] << path
  end

  if paths.size != 1
    counter << 'total'
    wc_rows << counter
  end
  adjust(wc_rows)
end

def print_standard(option)
  content = ''
  while (path = $stdin.gets)
    content += path
  end
  print wc_details(option, content) * ' '
end

def wc_details(option, content, path = '')
  wc_row = []
  contents = []
  content.split(' ').each_with_index { |word, index| contents[index] = word }
  capacity = if File.exist?(path)
               File.size(path)
             else
               content.bytesize
             end
  no_option = option.empty?
  all_details = {
    l: content.count("\n"),
    w: content.size,
    c: capacity
  }
  all_details.each do |key, value|
    wc_row << value if option[key] || no_option
  end
  wc_row
end

def adjust(wc_rows)
  data = wc_rows.map { |row| row.map(&:to_s) }
  columns = data.transpose
  widths = columns.map do |column|
    column.map(&:length).max
  end

  data.each do |row|
    target_element = row.map.with_index do |element, i|
      element.rjust(widths[i])
    end
    puts target_element.join(' ')
  end
end

main(**option)
