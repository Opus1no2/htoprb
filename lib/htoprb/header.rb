# frozen_string_literal: true

module Htoprb
  class Header
    attr_reader :height
    attr_accessor :total_tasks, :total_running

    HEIGHT = 8

    def initialize(window = Window.instance)
      @height = HEIGHT
      @window = window.win
    end

    def update_stats
      @window.setpos(0, 0)
      @window << "Tasks: #{total_tasks}, #{total_running} running"
      @window.setpos(1, 0)
      @window << "Uptime: #{uptime}"
    end

    def uptime
      platform.uptime[/(\d+\sday,\s\d+:\d+)/]
    end

    def platform
      @platform ||= Htoprb.platform
    end
  end
end
