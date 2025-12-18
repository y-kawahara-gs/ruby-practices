#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './option'
require_relative './file_list'

option = Option.new(ARGV)
filelist = FileList.new(option.status)

filelist.print_list
