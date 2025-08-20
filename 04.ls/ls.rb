#!/usr/bin/env ruby
# frozen_string_literal: true

def contents
  cd = File.absolute_path('.')
  Dir.entries(cd).sort
end

def print_ls
  contents.each_with_index do |file, index|
    next if file.start_with?('.')

    print "#{file}  "
    print "\n" if (index % 3).zero?
  end
end

print_ls
