# frozen_string_literal: true

module Htoprb
  class Process
    attr_accessor :win, :process, :column_widths, :selected, :header

    def initialize(process, column_widths)
      @process = process
      @column_widths = column_widths
    end

    def to_s
      process_parts = @process.split

      pid   = process_parts[0].rjust(column_widths['pid'])
      user  = process_parts[1][0..column_widths['user']].ljust(column_widths['user'] + 1)
      pri   = process_parts[2].rjust(column_widths['pri'])
      ni    = process_parts[3].rjust(column_widths['ni'])
      rss   = process_parts[4].rjust(column_widths['rss'])
      state = process_parts[5].rjust(column_widths['state'])
      cpu   = process_parts[6].rjust(column_widths['%cpu'])
      mem   = process_parts[7].rjust(column_widths['%mem'])
      time  = process_parts[8].rjust(column_widths['time'])
      command = extract_command(@process)

      [pid, user, pri, ni, rss, state, cpu, mem, time, command].join('  ')[0..Curses.cols].ljust(Curses.cols)
    end

    def extract_command(process)
      # This is brittle
      command_match = process.match(/\d{1,}:\d{2}.\d{2} (.*)/)
      command_match ? command_match.captures.first : 'Command'
    end
  end
end
