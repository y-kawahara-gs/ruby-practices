#!/usr/bin/env ruby
# frozen_string_literal: true

def contents
  files = Dir.glob("*")
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
