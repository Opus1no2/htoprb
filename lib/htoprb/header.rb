# frozen_string_literal: true

module Htoprb
  class Header
    attr_reader :height
    attr_accessor :total_tasks, :total_running

    HEIGHT = 8

    def initialize(window = Window.instance)
      @height = HEIGHT
      @window = window.win
      @total_uptime = 'NA'
      @load_average = 'NA'
    end

    def update_stats
      header_stats = combined_header_stats

      @window.setpos(0, 0)
      @window << "Tasks: #{total_tasks}, #{total_running} running"
      @window.setpos(1, 0)
      @window << "Load average: #{header_stats[:load_avg]}"
      @window.setpos(2, 0)
      @window << "Uptime: #{header_stats[:uptime]}"
      @window.setpos(3, 0)
      @window << "Swp: #{header_stats[:swap_usage].first} used: #{header_stats[:swap_usage].last}"
    end

    def combined_header_stats
      platform.combined_header_stats
    end

    def platform
      @platform ||= Htoprb.platform
    end
  end
end
