# frozen_string_literal: true

module Htoprb
  class Darwin
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

    def column_names
      COLUMN_MAPPING.map { |k, v| "#{k}=#{v}" }.join(',')
    end
  end
end