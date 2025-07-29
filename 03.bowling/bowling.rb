#!/usr/bin/env ruby
require 'debug'

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = shots.each_slice(2).to_a

point = frames.sum do |frame|
  binding.break
  if frame[0] == 10
    30
  elsif frame.sum == 10
    frame[0] + 10
  else
    frame.sum
  end
end

puts point
