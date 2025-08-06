#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = scores.flat_map { |s| s == 'X' ? [10, 0] : s.to_i }

frames = shots.each_slice(2).to_a

point = 0
frames.each_with_index do |frame, index|
  next if index > 9
  if frames[index].sum == 10
    point += frames[index].sum
    if frames[index][0] == 10
      point += frames[index + 1][0]
      if frames[index + 1][0] == 10
        point += frames[index + 2][0]
      else
        point += frames[index + 1][1]
      end
    else
      point += frames[index + 1][0]
    end
  else frames[index].sum != 10
    point += frames[index].sum
  end
end

puts point

