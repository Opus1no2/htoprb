# frozen_string_literal: true

module Htoprb
  class Platform
    def initialize(process)
      @process = process
    end

    def process_list
      serialized_process_list(platform.process_list).map do |proc|
        @process.new(proc)
      end
    end

    private

    # move to serializer
    def serialized_process_list(ray)
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

    def platform
      @platform ||= case os
                    when 'linux'
                      Htoprb::Linux.new
                    when 'darwin'
                      Htoprb::Darwin.new
                    else
                      raise StandardError, '[htoprb] - unsupported platform'
                    end
    end

    def os
      @os ||= Gem::Platform.local.os
    end
  end
end
