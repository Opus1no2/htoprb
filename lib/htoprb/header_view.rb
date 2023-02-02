# frozen_string_literal: true

module Htoprb
  class HeaderView
    include Singleton

    attr_reader :window

    def initialize(window = Window.instance)
      @window = window
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
