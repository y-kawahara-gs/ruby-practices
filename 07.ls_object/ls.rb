#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './option'
require_relative './system_controller'

result = SystemController.new

result.run
