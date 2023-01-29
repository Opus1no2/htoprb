# frozen_string_literal: true

require 'pry'
module Htoprb
  class ProcessListBase
    attr_accessor :process, :id

    def initialize(process, platform = Platform.instance)
      @process = process
      @platform = platform
      @process_list = []
    end

    def refresh_process_list
      @process_list = serialized_processes(@platform.platform.process_list).map.with_index do |proc, id|
        @process.new(proc, id)
      end

      @process_list.each do |process|
        process.generate_column_widths(column_widths)
      end

      @process_list
    end

    private

    def column_widths
      {
        'pri' => 2,
        'ni' => 2,
        'user' => 10,
        '%cpu' => 5,
        '%mem' => 5,
        'state' => 3,
        'time' => 8
      }.merge('pid' => max_pid, 'rss' => max_res)
    end

    def max_pid
      @process_list[1..].map { |p| p.process['pid'] }.max_by(&:length).length
    end

    def max_res
      @process_list[1..].map { |p| p.process['rss'] }.max_by(&:length).length
    end

    # move to serializer
    def serialized_processes(ray)
      ray.map do |line|
        process = line.split

        {
          'pid' => process[0],
          'user' => process[1],
          'pri' => process[2],
          'ni' => process[3],
          'rss' => process[4],
          'state' => process[5],
          '%cpu' => process[6],
          '%mem' => process[7],
          'time' => process[8],
          'command' => process[9..].join(' ') # only works if command is last
        }
      end
    end
  end
end
