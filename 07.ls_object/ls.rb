#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './option'
require_relative './list'

option = Option.new
list = List.new(option.judge(:a), option.judge(:r))
if option.judge(:l)
  list.print_file_details
else
  list.print_files
end
