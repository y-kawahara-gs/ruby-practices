# frozen_string_literal: true

require_relative './filelist'

class List
  attr_reader :file_list

  def initialize(all = nil, reverse = nil)
    @file_list = Filelist.new(all, reverse)
  end

  def print_files
    files_box = file_list.alingne_files
    files_box.each do |rows|
      rows.each do |file|
        print "#{file}  "
      end
      print "\n"
    end
  end

  def print_file_details
    puts file_list.return_total_block
    puts file_list.return_file_details
  end
end
