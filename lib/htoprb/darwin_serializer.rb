# frozen_string_literal: true

module Htoprb
  class DarwinSerializer
    include Singleton

    def sysctl_stats(stats)
      refined_stats = {}
      raw_stats = stats.split("\n")

      refined_stats[:phys_mem] = phys_mem(raw_stats[0])
      refined_stats[:swap_usage] = raw_stats[1]
      refined_stats[:load_avg] = load_avg(raw_stats[2])
      refined_stats[:uptime] = uptime(raw_stats[3])
      refined_stats
    end

    def load_avg(raw_load_avg)
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
