#!/usr/bin/env ruby
# frozen_string_literal: true

def strike(st_frame, st)
  if st_frame[st][0] == 10
    if st_frame[st + 1][0] == 10
      20 + st_frame[st + 2][0]
    else
      10 + st_frame[st + 1].sum
    end
  else
    0
  end
end

def spare(sp_frame, sp)
  if sp_frame[sp].sum == 10 && sp_frame[sp][0] != 10
    10 + sp_frame[sp + 1][0]
  else
    0
  end
end

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

  point += strike(frames, index)
  point += spare(frames, index)
  point += open_frame(frames, index)
end

puts point

