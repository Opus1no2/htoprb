# frozen_string_literal: true

module Htoprb
  class Header
    attr_reader :height, :view
    attr_accessor :total_tasks, :total_running

    HEIGHT = 8

    def initialize(view = HeaderView.instance)
      @view = view
      @height = HEIGHT
      @total_uptime = 'NA'
      @total_running = 'NA'
      @total_tasks = 'NA'
      @load_average = 'NA'
    end

    def update_stats
      stats = combined_header_stats

      view.tasks(stats[:total_tasks], stats[:total_running])
      view.load_average(stats[:load_avg])
      view.uptime(stats[:uptime])
      view.swap(stats[:swap_total], stats[:swap_used])
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
  end
end
