# frozen_string_literal: true

module Htoprb
  class Darwin
    attr_reader :serializer

    def initialize(serializer = DarwinSerializer.instance)
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
      stdout, _stderr, _wait_thr = Open3.capture3('ps', 'axro', column_names)
      stdout.split("\n")
    end

    def uptime
      stdout, _stderr, _wait_thr = Open3.capture3('uptime')
      stdout
    end

    def combined_header_stats
      serializer.sysctl_stats(`sysctl -n hw.memsize vm.swapusage vm.loadavg kern.boottime`)
    end

    def max_pid
      99_999
    end

    def column_names
      COLUMN_MAPPING.map { |k, v| "#{k}=#{v}" }.join(',')
    end
  end
end
