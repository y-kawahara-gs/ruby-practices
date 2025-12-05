# frozen_string_literal: true

require 'optparse'

class Option
  attr_reader :status

  def initialize
    opt = OptionParser.new
    params = {}
    opt.on('-a') { |v| params[:a] = v }
    opt.on('-r') { |v| params[:r] = v }
    opt.on('-l') { |v| params[:l] = v }
    opt.parse!(ARGV)

    @status = params
  end

  def judge(option_key)
    status[option_key]
  end
end
