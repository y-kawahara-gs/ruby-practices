#! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main(opt)
  if ARGV.empty?
    print_standard(opt)
  else
    print_argument(opt)
  end
end

def print_argument(option)
  paths = ARGV
  wc_rows = paths.map do |path|
    content = File.read(path)
    temporary_details = get_wc_details(content)
    temporary_details << path
    temporary_details
  end

  if paths.size > 1
    total = wc_rows.transpose.map do |row|
      row.sum if row.all? { |row| row.instance_of?(Integer) }
    end
    wc_rows << total.map { |row| row.nil? ? 'total' : row }
  end
  print_adjusted_wc(wc_rows, option)
end

def print_standard(option)
  contents = ''
  while (content = $stdin.gets)
    contents += content
  end
  puts judge_option(get_wc_details(contents), option).join(' ')
end

def get_wc_details(content)
  contents = []
  content.split(' ').each_with_index { |word, index| contents[index] = word }
  [content.count("\n"), contents.size, content.bytesize]
end

def print_adjusted_wc(wc_rows, option)
  temporary_details = wc_rows.map { |row| row.map(&:to_s) }
  vertical_details = temporary_details.transpose
  judge_option(vertical_details, option)

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

def judge_option(wc_rows, option)
  wc_rows.delete_at(2) unless option[:c] || option.empty?
  wc_rows.delete_at(1) unless option[:w] || option.empty?
  wc_rows.delete_at(0) unless option[:l] || option.empty?
  wc_rows
end

def load_option
  options = {}
  opt = OptionParser.new
  opt.on('-l') { |v| options[:l] = v }
  opt.on('-w') { |v| options[:w] = v }
  opt.on('-c') { |v| options[:c] = v }
  opt.parse!(ARGV)
  options
end

main(load_option)
