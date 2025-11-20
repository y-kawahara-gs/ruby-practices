# frozen_string_literal: true

require_relative 'frame'

class Game
  attr_reader :frames

  def initialize(received_scores)
    flat_scores = received_scores.flat_map { |shot| shot == 'X' ? ['X', 0] : shot }
    frames_argument_list = flat_scores.each_slice(2).to_a
    @frames = frames_argument_list.map.with_index do |frame_mark, index|
      Frame.new(frame_mark[0], frame_mark[1], frame_mark[2])
    end
  end

  def score
    frames.each_with_index.sum do |frame, index|
      base_score = frame.score
      bonus_score = if index < 9
                      if frame.spare
                        frames[index + 1].first_shot.score
                      elsif frame.strike
                        next_score = frames[index + 1].first_shot.score + frames[index + 1].second_shot.score
                        next_score += frames[index + 2].first_shot.score if frames[index + 1].first_shot.score == 10
                        next_score
                      else
                        0
                      end
                    else
                      0
                    end
      base_score + bonus_score
    end
  end
end
