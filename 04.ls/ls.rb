#!/usr/bin/env ruby
# frozen_string_literal: true

def contents
  path = File.absolute_path('.')
  files = Dir.entries(path).sort.reject do |element|
    element.start_with?('.')
  end

  cols = 3
  rows = files.length.ceildiv(cols)
  files_arrays = Array.new(rows) { Array.new(cols) }

  files.each_with_index do |file, index|
    row = index % rows
    col = index / rows
    files_arrays[row][col] = file
  end
  files_arrays
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
