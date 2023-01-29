# frozen_string_literal: true

require 'pry'
module Htoprb
  class ProcessListBase
    attr_accessor :process, :id

    def initialize(process,
                   serializer = ProcessSerializer.instance)

      @process = process
      @platform = platform
      @serializer = serializer
      @process_list = []
    end

    def platform
      @platform ||= Htoprb.platform
    end

    def refresh_process_list
      @process_list = @serializer
                      .serialized_processes(platform.process_list)
                      .map.with_index do |proc, id|
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
  end
end
