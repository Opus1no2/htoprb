# frozen_string_literal: true

module Htoprb
  class Platform
    include Singleton

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
