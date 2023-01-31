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
      calculate_uptime

      @window.setpos(0, 0)
      @window << "Tasks: #{total_tasks}, #{total_running} running"
      @window.setpos(1, 0)
      @window << "Load average: #{@load_average}"
      @window.setpos(2, 0)
      @window << "Uptime: #{@total_uptime}"
    end

    def calculate_uptime
      # surely there's a better way...
      unless /up\s(?<uptime>\d+\sday,\s\d+:\d+)\s*,.*load averages:\s(?<load_avg>\d+\.\d+\s\d+\.\d+\s\d+\.\d+)/ =~ platform.uptime
        return
      end

      @total_uptime = uptime
      @load_average = load_avg
    end

    def platform
      @platform ||= Htoprb.platform
    end
  end
end
