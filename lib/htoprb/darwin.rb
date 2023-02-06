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
      `ps axro #{column_names}`.split("\n")
    end

    def mem_stats
      serializer.mem_stats(`sysctl -n hw.memsize vm.swapusage`)
    end

    def load_average
      serializer.load_average(`sysctl -n vm.loadavg`)
    end

    def uptime
      serializer.uptime(`sysctl -n kern.boottime`)
    end

    def max_pid
      99_999
    end

    def column_names
      COLUMN_MAPPING.map { |k, v| "#{k}=#{v}" }.join(',')
    end
  end
end
