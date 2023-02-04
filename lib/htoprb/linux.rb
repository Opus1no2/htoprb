# frozen_string_literal: true

module Htoprb
  class Linux
    attr_reader :serializer

    STAT_INFO_PATH = '/proc/stat'
    MEM_INFO_PATH  = '/proc/meminfo'
    LOAD_AVG_PATH  = '/proc/loadavg'
    UPTIME_PATH    = '/proc/uptime'

    def initialize(serializer = LinuxSerializer.instance)
      @serializer = serializer
    end

    COLUMN_MAPPING = {
      'pid' => 'PID',
      'user' => 'USER',
      'pri' => 'PRI',
      'ni' => 'NI',
      'rss' => 'RES',
      'state' => 'S',
      '%cpu' => 'CPU%',
      '%mem' => 'MEM%',
      'time' => 'Time',
      'command' => 'Command'
    }.freeze

    def cores
      @cores ||= `nproc`.to_i
    end

    def process_list
      `ps axo #{column_names} --sort -%cpu`.split("\n")
    end

    def cpu_info
      serializer.serialized_cpu_info(File.read(STAT_INFO_PATH), cores)
    end

    def mem_stats
      stats = serializer.mem_stats(File.read(MEM_INFO_PATH))

      swap_total = stats[:swap_total]
      swap_used = swap_total - stats[:swap_free]
      physical_memory = stats[:phyical_memory]

      {
        swap_total:,
        swap_used:,
        physical_memory:
      }
    end

    def load_average
      serializer.load_average(File.read(LOAD_AVG_PATH))
    end

    def uptime
      serializer.uptime(File.read(UPTIME_PATH))
    end

    def max_pid
      99_999 # this needs to be dynamic
    end

    def column_names
      COLUMN_MAPPING.map { |k, v| "#{k}=#{v}" }.join(',')
    end
  end
end
