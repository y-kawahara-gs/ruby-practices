#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = scores.flat_map { |s| s == 'X' ? [10, 0] : s.to_i }

frames = shots.each_slice(2).to_a

point = frames.take(10).each_with_index.sum do |frame, index|
  base_score = frames[index].sum
  bonus = if frames[index].sum < 10
            0
          elsif frames[index][0] != 10
            frames[index + 1][0]
          else
            next_score = frames[index + 1].sum
            next_score += frames[index + 2][0] if frames[index + 1][0] == 10
          end
  base_score + bonus
end
puts point

