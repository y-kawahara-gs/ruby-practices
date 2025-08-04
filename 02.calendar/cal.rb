#!/usr/bin/env ruby

require 'optparse'
require 'date'

opt = OptionParser.new
month_year_opt = opt.getopts(ARGV, "m:", "y:")

month = month_year_opt["m"].to_i
year = month_year_opt["y"].to_i

today = Time.now

if month == 0 && year == 0
  month = today.month
  year = today.year
elsif year == 0
  year = today.year
end

date_f = Date.new(year, month, 1)
date_l = Date.new(year, month, -1)


puts "#{date_f.strftime('%B')} #{year}".center(21)
puts "Su Ma Tu We Th Fr Sa"

wday_f = date_f.wday
blank = "   "*wday_f
print blank

(date_f..date_l).each do |x|
  if x.strftime('%a') == "Sat" && x.strftime('%-d').to_i < 10
    print " #{x.strftime('%-d')}\n"
  elsif x.strftime('%a') == 'Sat'
    print "#{x.strftime('%-d')}\n"
  elsif x.strftime('%-d').to_i < 10
    print " #{x.strftime('%-d')} "
  else
    print "#{x.strftime('%-d')} "
  end
end

