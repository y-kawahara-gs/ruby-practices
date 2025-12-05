# frozen_string_literal: true

require_relative './list'

class SystemController
  attr_reader :option, :list

  def initialize
    @option = Option.new
    @list = List.new(option.judge(:a), option.judge(:r))
  end

  def run
    if option.judge(:l)
      list.print_file_details
    else
      list.print_files
    end
  end
end
