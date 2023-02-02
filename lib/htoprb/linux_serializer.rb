# frozen_string_literal: true

module Htoprb
  class LinuxSerializer
    include Singleton

    def combined_header_stats(mem_info, load_avg, uptime)
      {
        total_mem: total_mem(mem_info),
        swap_total: swap_total(mem_info),
        swap_free: swap_free(mem_info),
        load_avg: load_average(load_avg),
        uptime: uptime(uptime)
      }
    end

    def total_mem(mem_info)
      mem_info.match(/MemTotal:\s{1,}(\d{1,})/).captures.first.to_i
    end

    def swap_total(mem_info)
      mem_info.match(/SwapTotal:\s{1,}(\d{1,})/).captures.first.to_i
    end

    def swap_free(mem_info)
      mem_info.match(/SwapFree:\s{1,}(\d{1,})/).captures.first.to_i
    end

    def load_average(load_avg)
      load_avg.split[0..-3].map(&:to_f).join(' ')
    end

    def uptime(uptime)
      seconds = uptime.split.first
      seconds_to_human_readable(seconds)
    end

    def seconds_to_human_readable(seconds)
      days = seconds.to_i / 86_400
      hours = (seconds.to_i % 86_400) / 3600
      minutes = (seconds.to_i % 3600) / 60
      remaining_seconds = seconds.to_i % 60

      "#{days} day(s), #{hours}:#{minutes}:#{remaining_seconds}"
    end
  end
end
