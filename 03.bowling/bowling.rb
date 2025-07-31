#!/usr/bin/env ruby
require 'debug'

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

def open(all_frame_op, op_frame)
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
  # binding.break
  if index < 9
    point += strike(frames, index)
    point += spare(frames, index)
    point += open(frames, index)
  end

  if index == 9
    point += strike(frames, index)

=begin
    if frames[index][0] == 10
      if frames[index + 1][0] == 10
        point += (20 + frames[index + 2][0])
      else
        point += (10 + frames[index + 1].sum)
      end
    end
=end
  point += spare(frames, index)
=begin
    if frames[index].sum == 10 && frames[index][0] != 10
      point += (10 + frames[index + 1][0])
    end
=end
  point += open(frames, index)
  end
end

=begin
frames.each_with_index do |_frame, index|
  if index < 9
    if frames[index][0] == 10
      if frames[index + 1][0] == 10
        point += (20 + frames[index + 2][0])
      else
        point += (10 + frames[index + 1].sum)
      end
    elsif frames[index].sum == 10
      point += (10 + frames[index + 1][0])
    else
      point += frames[index].sum
    end
  end

  if index == 9
    if frames[index][0] == 10
      if frames[index + 1][0] == 10
        point += (20 + frames[index + 2][0])
      else
        point += (10 + frames[index + 1].sum)
      end
      break
    elsif frames[index].sum == 10
      point += (10 + frames[index + 1][0])
      break
    else
      point += frames[index].sum
    end
  end
end
=end

puts point
