# frozen_string_literal: true

module Htoprb
  class Header
    attr_reader :height
    attr_accessor :total_tasks

    HEIGHT = 8

    def initialize(window = Window.instance)
      @height = HEIGHT
      @window = window.win
    end

    def update_stats
      @window.setpos(0, 0)
      @window << "Tasks: #{total_tasks}"
    end
  end
end
