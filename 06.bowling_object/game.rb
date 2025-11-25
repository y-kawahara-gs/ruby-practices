# frozen_string_literal: true

require_relative 'frame'

class Game
  attr_reader :frames

  def initialize(received_scores)
    flat_scores = received_scores.flat_map { |shot| shot == 'X' ? ['X', 0] : shot }
    all_frames = flat_scores.each_slice(2).to_a

    frames_before_nine = all_frames[0..8]
    frames_ten = all_frames[9..]
    frame_ten_throws = frames_ten.flat_map do |element|
      element.reject { |shot| shot.instance_of?(Integer) && shot.zero? }
    end

    frame_informations = frames_before_nine + [frame_ten_throws]
    @frames = frame_informations.map do |frame_mark|
      Frame.new(frame_mark[0], frame_mark[1], frame_mark[2])
    end
  end

  def score
    frames.each_with_index.sum do |frame, index|
      base_score = frame.score

      bonus_score = if index < 9
                      frame.score_of_spare_or_strike(frames[index + 1], frames[index + 2])
                    else
                      0
                    end
      base_score + bonus_score
    end
  end
end
