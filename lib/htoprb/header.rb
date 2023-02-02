# frozen_string_literal: true

module Htoprb
  class Header
    attr_reader :height, :view
    attr_accessor :total_tasks, :total_running, :combined_header_stats

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
      header_stats = combined_header_stats

      view.tasks(total_tasks, total_running)
      view.load_average(header_stats[:load_avg])
      view.uptime(header_stats[:uptime])
      view.swap(header_stats[:swap_total], header_stats[:swap_used])
    end

    def combined_header_stats
      platform.combined_header_stats
    end

    def platform
      @platform ||= Htoprb.platform
    end
  end
end
