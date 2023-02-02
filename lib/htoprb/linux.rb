# frozen_string_literal: true

module Htoprb
  class Linux
    attr_reader :serializer

    MEM_INFO_PATH = '/proc/meminfo'
    LOAD_AVG_PATH = '/proc/loadavg'
    UPTIME_PATH   = '/proc/uptime'

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

    def process_list
      stdout, _stderr, _wait_thr = Open3.capture3('ps', 'axo', column_names, '--sort', '-%cpu')
      stdout.split("\n")
    end

    def combined_header_stats
      serializer.combined_header_stats(mem_info, load_avg, uptime)
    end

    def mem_info
      File.read(MEM_INFO_PATH)
    end

    def load_avg
      File.read(LOAD_AVG_PATH)
    end

    def uptime
      File.read(UPTIME_PATH)
    end

    def max_pid
      99_999
    end

    def column_names
      COLUMN_MAPPING.map { |k, v| "#{k}=#{v}" }.join(',')
    end
  end
end
