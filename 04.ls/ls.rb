#!/usr/bin/env ruby
# frozen_string_literal: true

def contents
  files = Dir.glob("*")
  rows = files.length.ceildiv(3)
  file_grid = Array.new(rows) { Array.new(3) }

  files.each_with_index do |file, index|
    row = index % rows
    col = index / rows
    file_grid[row][col] = file
  end
  file_grid
end

def print_ls
  contents.each do |file_arrays|
    file_arrays.each do |file|
      print "#{file}  "
    end
    print "\n"
  end
end

print_ls
