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

date_first = Date.new(year, month, 1)
date_last = Date.new(year, month, -1)

puts "#{date_first.strftime('%B')} #{year}".center(21)
puts "Su Ma Tu We Th Fr Sa"

wday_f = date_first.wday
print "   "*wday_f

(date_first..date_last).each do |date|
  print "#{date.day}".rjust(3)
  if date.saturday?
    print "\n"
  end
end

