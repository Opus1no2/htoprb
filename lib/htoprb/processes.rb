module Htoprb
  class Processes
    attr_accessor :total, :processes

    def running_processes
      Open3.capture3('ps', 'aux')
    end

    def self.call
      new.call
    end

    def call
      stdout, stderr, wait_thr = running_processes
      processes = stdout.split("\n")[1..]

      @total = processes.length.to_s
      @processes = processes

      self
    end
  end
end
