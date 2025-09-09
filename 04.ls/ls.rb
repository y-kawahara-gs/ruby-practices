#!/usr/bin/env ruby
# frozen_string_literal: true
require 'optparse'
require 'etc'
require 'date'

def main
  Contents.option
  Contents.details
  Display.print_ls
end

class Contents
  @@option = {}
  def self.option
    opt = OptionParser.new
    opt.on('-a') { |v| @@option[:a] = v }
    opt.on('-r') { |v| @@option[:r] = v }
    opt.on('-l') { |v| @@option[:l] = v }
    opt.parse!(ARGV)
  end

  def self.details
    option_a = (@@option[:a] == true ? File::FNM_DOTMATCH : 0)
    files = Dir.glob("*", option_a)
    files = files.reverse if @@option[:r]
    
    rows = files.length.ceildiv(3)
    file_rows = Array.new(rows) { Array.new(3) }
    files.each_with_index do |file, index|
      row = index % rows
      col = index / rows
      file_rows[row][col] = file
    end
    @@option[:l] == true ? files : file_rows
  end
end

class Display < Contents
  def self.print_ls
    if @@option[:l]
      Display.total
      details.each do |file|
        info = File.stat(file)
        mode = info.mode.to_s(8)

        mode.gsub!(/14+(\d{4})/, 's\\1')
        mode.gsub!(/12+(\d{4})/, 'l\\1')
        mode.gsub!(/10+(\d{4})/, '-\\1')
        mode.gsub!(/6+(\d{4})/, 'b\\1')
        mode.gsub!(/4+(\d{4})/, 'd\\1')
        mode.gsub!(/2+(\d{4})/, 'c\\1')
        mode.gsub!(/1+(\d{4})/, 'p\\1')

        mode.gsub!(/0+(\d{3})/, '\\1')

        2.downto(0) do |p|
          mode.gsub!(/0+(\d{#{p}})$/, '---\\1')
          mode.gsub!(/1+(\{{#{p}})$/, '--x\\1')
          mode.gsub!(/2+(\d{#{p}})$/, '-w-\\1')
          mode.gsub!(/3+(\d{#{p}})$/, '-wx\\1')
          mode.gsub!(/4+(\d{#{p}})$/, 'r--\\1')
          mode.gsub!(/5+(\d{#{p}})$/, 'r-x\\1')
          mode.gsub!(/6+(\d{#{p}})$/, 'rw-\\1')
          mode.gsub!(/7+(\d{#{p}})$/, 'rwx\\1')
        end

        link = info.nlink
        owner = Etc.getpwuid(info.uid).name
        group = Etc.getpwuid(info.gid).name
        byte = info.size
        time = info.mtime

        print "#{mode} #{link} #{owner} #{group} "
        print "#{byte} ".rjust(5)
        print "#{time.to_date.strftime('%b')}"
        print "#{time.to_date.strftime('%e')} ".rjust(4)
        print "#{time.strftime('%H')}:#{time.strftime('%M')} "
        print "#{file}\n"
      end
    else
      details.each do |file_rows|
        file_rows.each do |file|
          print "#{file}  "
        end
        print "\n"
      end
    end
  end

  def self.total
    total_size = Contents.details.each.sum do |one_size|
      File.stat(one_size).blocks
    end
    puts "total #{total_size/2}"
  end
end

main
