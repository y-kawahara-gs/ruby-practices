#!/usr/bin/env ruby

# frozen_string_literal: true

def strike(all_frame_st, st_frame)
  if all_frame_st[st_frame][0] == 10
    if all_frame_st[st_frame + 1][0] == 10
      20 + all_frame_st[st_frame + 2][0]
    else
      10 + all_frame_st[st_frame + 1].sum
    end
  else
    0
  end
end

def spare(all_frame_sp, sp_frame)
  if all_frame_sp[sp_frame].sum == 10 && all_frame_sp[sp_frame][0] != 10
    10 + all_frame_sp[sp_frame + 1][0]
  else
    0
  end
end

def open_frame(all_frame_op, op_frame)
  if all_frame_op[op_frame].sum != 10
    all_frame_op[op_frame].sum
  else
    0
  end
end

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

point = 0
frames.each_with_index do |_frame, index|
  next if index > 9

  point += strike(frames, index)
  point += spare(frames, index)
  point += open_frame(frames, index)
end

puts point
