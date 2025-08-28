#!/usr/bin/env ruby
# frozen_string_literal: true
require 'optparse'

opt = OptionParser.new
opt.on('-a') { |v| p v }

def contents
  if ARGV.any?(/-\w/) == true
    if ARGV.any?(/a/) == true
      files = Dir.glob("*", File::FNM_DOTMATCH)
    end
  else
    files = Dir.glob("*")
  end
  rows = files.length.ceildiv(3)
  file_rows = Array.new(rows) { Array.new(3) }

  files.each_with_index do |file, index|
    row = index % rows
    col = index / rows
    file_rows[row][col] = file
  end
  file_rows
end

def print_ls
  contents.each do |file_rows|
    file_rows.each do |file|
      print "#{file}  "
    end
    print "\n"
  end
end

print_ls
