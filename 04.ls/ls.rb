#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'

def main
  display(**option)
end

def option
  options = {}
  opt = OptionParser.new
  opt.on('-a') { |v| options[:a] = v }
  opt.on('-r') { |v| options[:r] = v }
  opt.on('-l') { |v| options[:l] = v }
  opt.parse!(ARGV)
  options
end

def get_file(**options)
  option_a = (options[:a] ? File::FNM_DOTMATCH : 0)
  files = Dir.glob('*', option_a)
  files = files.reverse if options[:r]
  files
end

def display(**options)
  opt = options
  files = get_file(**opt)
  if options[:l]
    total_size = files.each.sum { |one_size| File.stat(one_size).blocks }
    puts "total #{total_size / 2}"
    files.each do |file|
      info = File.stat(file)
      mode = info.mode.to_s(8)
      mode.insert(0, '0') if mode.length == 5
      print_type(mode)
      print_permission(mode)
      l_option(info, file)
    end
  else
    no_l_option(files)
  end
end

def print_type(mode)
  type =
    {
      '14' => 's',
      '12' => 'l',
      '10' => '-',
      '06' => 'b',
      '04' => 'd',
      '02' => 'c'
    }[mode[0, 2]]
  print type
end

def print_permission(mode)
  (3..5).each do |num|
    permission =
      {
        '0' => '---',
        '1' => '--x',
        '2' => '-w-',
        '3' => '-wx',
        '4' => 'r--',
        '5' => 'r-x',
        '6' => 'rw-',
        '7' => 'rwx'
      }[mode[num]]
    print permission
  end
end

def l_option(info, file)
  link = info.nlink
  owner = Etc.getpwuid(info.uid).name
  group = Etc.getpwuid(info.gid).name
  byte = info.size
  time = info.mtime

  print " #{link} #{owner} #{group} "
  print "#{byte} ".rjust(5)
  print time.strftime('%b')
  print "#{time.strftime('%e')} ".rjust(4)
  print time.strftime('%R')
  print " #{file}\n"
end

def no_l_option(files)
  rows = files.length.ceildiv(3)
  file_rows = Array.new(rows) { Array.new(3) }
  files.each_with_index do |file, index|
    row = index % rows
    col = index / rows
    file_rows[row][col] = file
  end
  file_rows.each do |rows|
    rows.each do |file|
      print "#{file}  "
    end
    print "\n"
  end
end

main
