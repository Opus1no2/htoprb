# frozen_string_literal: true

module Htoprb
  class LinuxSerializer
    include Singleton

    def serialized_cpu_info(raw_stats, cores)
      raw_stats[1..cores].each_with_object({}) do |row, obj|
        parts = row.split

        obj[parts[0]] = parts[1..5]
      end
    end

    def mem_stats(mem_info)
      {
        phyical_memory: total_mem(mem_info),
        swap_total: swap_total(mem_info),
        swap_free: swap_free(mem_info)
      }
    end

    def total_mem(mem_info)
      (mem_info.match(/MemTotal:\s{1,}(\d{1,})/)
              .captures
              .first
              .to_f / 1024 / 1024).round(2)
    end

    def swap_total(mem_info)
      mem_info.match(/SwapTotal:\s{1,}(\d{1,})/)
              .captures
              .first
              .to_f / 1024 / 1024
    end

    def swap_free(mem_info)
      mem_info.match(/SwapFree:\s{1,}(\d{1,})/)
              .captures
              .first
              .to_f / 1024 / 1024
    end

    def load_average(load_avg)
      load_avg.split[0..-3].map(&:to_f).join(' ')
    end

    def uptime(uptime)
      seconds_to_human_readable(uptime.split.first)
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
