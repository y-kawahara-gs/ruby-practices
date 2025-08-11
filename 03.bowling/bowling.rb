#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = scores.flat_map { |s| s == 'X' ? [10, 0] : s.to_i }

frames = shots.each_slice(2).to_a

point = frames.take(10).each_with_index.sum do |frame, index|
  if frames[index].sum < 10
    frames[index].sum
  elsif frames[index][0] != 10
    frames[index].sum + frames[index + 1][0]
  else
    if frames[index + 1][0] == 10
      frames[index].sum + frames[index + 1].sum + frames[index + 2][0]
    else
      frames[index].sum +frames[index + 1].sum
    end
  end
end
puts point

