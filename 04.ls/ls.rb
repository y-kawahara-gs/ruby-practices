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

def details(**options)
  option_a = (options[:a] == true ? File::FNM_DOTMATCH : 0)
  files = Dir.glob('*', option_a)
  files = files.reverse if options[:r]
  rows = files.length.ceildiv(3)
  file_rows = Array.new(rows) { Array.new(3) }
  files.each_with_index do |file, index|
    row = index % rows
    col = index / rows
    file_rows[row][col] = file
  end
  options[:l] == true ? files : file_rows
end

def display(**options)
  opt = options
  if options[:l]
    total(**opt)

    details(**opt).each do |file|
      info = File.stat(file)
      mode = info.mode.to_s(8)
      mode.insert(0, '0') if mode.length == 5
      permission(mode)
      l_option(info, file)
   end
  else
    details(**opt).each do |file_rows|
      file_rows.each do |file|
        print "#{file}  "
      end
      print "\n"
    end
  end
end

def total(**options)
  opt = options
  total_size = details(**opt).each.sum do |one_size|
    File.stat(one_size).blocks
  end
  puts "total #{total_size / 2}"
end

def permission(mode)
  case mode[0, 2]
  when '14' then print 's'
  when '12' then print 'l'
  when '10' then print '-'
  when '06' then print 'b'
  when '04' then print 'd'
  when '02' then print 'c'
  end
  (3..5).each do |num|
    case mode[num]
    when '0' then print '---'
    when '1' then print '--x'
    when '2' then print '-w-'
    when '3' then print '-wx'
    when '4' then print 'r--'
    when '5' then print 'r-x'
    when '6' then print 'rw-'
    when '7' then print 'rwx'
    end
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

main
