#!/usr/bin/env ruby
# frozen_string_literal: true


def open_frame(op_frame, op)
  if op_frame[op].sum != 10
    op_frame[op].sum
  else
    0
  end
end

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
      if frames[index + 1][0] == 10
        point += frames[index + 1][0] + frames[index + 2][0]
      else
        point += frames[index + 1].sum
      end
    end
    if frames[index][0] != 10
      point += frames[index + 1][0]
    end
  end
  if frames[index].sum != 10
    point += frames[index].sum
  end
end

puts point

