# frozen_string_literal: true

module Htoprb
  class DarwinSerializer
    include Singleton

    def mem_stats(raw_mem)
      stats = raw_mem.split("\n")
      swap_total = swap_total(stats.last)
      swap_free  = swap_free(stats.last)
      swap_used  = swap_total - swap_free

      {
        physical_memory: phys_mem(stats.first),
        swap_total:,
        swap_used:
      }
    end

    def swap_total(raw_swap)
      raw_swap.match(/total\s=\s(\d\.\d{1,})/).captures.first.to_f
    end

    def swap_free(raw_swap)
      raw_swap.match(/free\s=\s(\d\.\d{1,})/).captures.first.to_f
    end

    def load_average(raw_load_avg)
      raw_load_avg.split[1..-2].join(' ')
    end

    def phys_mem(raw_mem)
      raw_mem.gsub(',', '').to_i / 1024 / 1024 / 1024
    end

    def uptime(raw_uptime)
      diff = DateTime.now - DateTime.parse(raw_uptime.split('}').last.strip)

      days = diff.to_i
      hours = (diff - days) * 24
      minutes = (hours - hours.to_i) * 60
      seconds = (minutes - minutes.to_i) * 60

      "#{days} day(s) #{hours.to_i}:#{minutes.to_i}:#{seconds.to_i}"
    end
  end
end
