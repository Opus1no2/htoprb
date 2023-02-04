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
      mem_stats = platform.mem_stats

      tasks(total_tasks, total_running)
      load_average(platform.load_average)
      uptime(platform.uptime)
      phys_mem(mem_stats[:physical_memory])
      swap(mem_stats[:swap_total], mem_stats[:swap_used])
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

    def phys_mem(total)
      window.setpos(3, 0)
      window << "Mem: #{total}G"
    end

    def swap(total, used)
      window.setpos(4, 0)
      window << "Swp: #{total}GB used: #{used}GB"
    end
  end
end
