#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './option'
require_relative './list'

option = Option.new(ARGV)
list = List.new(option.exist?(:a), option.exist?(:r))
if option.exist?(:l)
  list.print_file_details
else
  list.print_files
end
