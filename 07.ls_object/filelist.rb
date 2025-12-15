# frozen_string_literal: true

require_relative './file'

class Filelist
  def initialize(option)
    dot_file_option = option[:a] ? File::FNM_DOTMATCH : 0
    file_names = Dir.glob('*', dot_file_option)
    @file_names = option[:r] ? file_names.reverse : file_names
    @list = option[:l]
  end

  def aligned_files
    file_names = @file_names
    rows = file_names.length.ceildiv(3)
    file_rows = Array.new(rows) { Array.new(3) }
    file_names.each_with_index do |file_name, index|
      row = index % rows
      col = index / rows
      file_rows[row][col] = file_name
    end

    aligned_file_colums = file_rows.transpose.map do |colums|
      max_length = colums.max_by { |file| file.to_s.length }&.length
      colums.map do |file|
        file&.ljust(max_length)
      end
    end
    aligned_file_colums.transpose
  end

  def return_total_block
    total_size = @file_names.each.sum { |one_size| File.stat(one_size).blocks }
    "total #{total_size / 2}"
  end

  def return_file_details
    @file_names.map do |filename|
      file = MyLs::File.new(filename)
      file.return_detail
    end
  end

  def print_files
    files_box = aligned_files
    files_box.each do |rows|
      rows.each do |file|
        print "#{file} "
      end
      print "\n"
    end
  end

  def print_file_details
    puts return_total_block
    puts return_file_details
  end

  def print_list
    @list ? print_file_details : print_files
  end
end
