#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'
require_relative 'game'

score = ARGV[0]
scores = score.split(',')
game = Game.new(scores)
p game.score
