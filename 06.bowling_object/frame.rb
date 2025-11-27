# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_mark, second_mark, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def score
    [first_shot, second_shot, third_shot].map(&:score).sum
  end

  def score_of_spare_or_strike(next_frame, after_next_frame)
    if spare?
      next_frame.first_shot.score
    elsif strike?
      bonus = next_frame.first_shot.score + next_frame.second_shot.score
      bonus += after_next_frame.first_shot.score if next_frame.strike? && !after_next_frame.nil?
      bonus
    else
      0
    end
  end

  def strike?
    first_shot.score == 10
  end

  def spare?
    first_shot.score != 10 && (first_shot.score + second_shot.score) == 10
  end
end
