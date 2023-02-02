# frozen_string_literal: true

module Htoprb
  class Header
    attr_reader :height, :window
    attr_accessor :total_tasks, :total_running

    HEIGHT = 8

    def initialize(window = Window.instance)
      @window = window
      @height = HEIGHT
      @total_uptime = 'NA'
      @total_running = 'NA'
      @total_tasks = 'NA'
      @load_average = 'NA'
    end

    def update_stats
      stats = combined_header_stats

      tasks(stats[:total_tasks], stats[:total_running])
      load_average(stats[:load_avg])
      uptime(stats[:uptime])
      swap(stats[:swap_total], stats[:swap_used])
    end

    def combined_header_stats
      platform.combined_header_stats.merge(
        total_tasks:,
        total_running:
      )
    end

    def platform
      @platform ||= Htoprb.platform
    end

    def tasks(total, running)
      window.setpos(0, 0)
      window << "Tasks: #{total}, #{running} running"
    end

    def load_average(load_average)
      window.setpos(1, 0)
      window << "Load average: #{load_average}"
    end

    def uptime(uptime)
      window.setpos(2, 0)
      window << "Uptime: #{uptime}"
    end

    def swap(total, used)
      window.setpos(3, 0)
      window << "Swp: #{total}GB used: #{used}GB"
    end
  end
end
