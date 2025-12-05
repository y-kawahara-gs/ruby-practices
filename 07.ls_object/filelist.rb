# frozen_string_literal: true

require_relative './file'

class Filelist
  attr_reader :files

  def initialize(all = nil, reverse = nil)
    option_a = all ? File::FNM_DOTMATCH : 0
    files = Dir.glob('*', option_a)
    @files = reverse ? files.reverse : files
  end

  def alingne_files
    rows = files.length.ceildiv(3)
    file_rows = Array.new(rows) { Array.new(3) }
    files.each_with_index do |file, index|
      row = index % rows
      col = index / rows
      file_rows[row][col] = file
    end

    aligned_file_colums = file_rows.transpose.map do |colum|
      max_length = colum.max_by { |file| file.to_s.length }&.length
      colum.map do |file|
        file&.ljust(max_length)
      end
    end
    aligned_file_colums.transpose
  end

  def return_total_block
    total_size = files.each.sum { |one_size| File.stat(one_size).blocks }
    "total #{total_size / 2}"
  end

  def return_file_details
    files.map do |filename|
      file = MyLs::File.new(filename)
      file.return_detail
    end
  end
end
