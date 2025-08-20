#!/usr/bin/env ruby
# frozen_string_literal: true

def contents
  path = File.absolute_path('.')
  files = Dir.entries(path).sort.reject {
    |element| element.start_with?('.')
  }

  cols = 3
  rows = (files.length.to_f / cols).ceil
  files_array = Array.new(rows) { Array.new(cols) }
  count = -1
 
  files.each_with_index do |file, index|
    row = index % rows
    col = index / rows
    files_array[row][col] = file
  end
  files_array
end

def print_ls
  contents.each_with_index do |file_array, index|
    file_array.each do |file|
      print "#{file}  "
    end
    print "\n"
  end
end

print_ls
