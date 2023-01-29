# frozen_string_literal: true

module Htoprb
  class Process
    attr_accessor :id, :process

    def initialize(process, id)
      @process = process
      @id = id
      @selected = false
      @padded_row = ''
    end

    def generate_column_widths(column_widths)
      @padded_row = [
        @process['pid'].rjust(column_widths['pid']),
        @process['user'][0..column_widths['user']].ljust(column_widths['user'] + 1),
        @process['pri'].rjust(column_widths['pri']),
        @process['ni'].rjust(column_widths['ni']),
        @process['rss'].rjust(column_widths['rss']),
        @process['state'].rjust(column_widths['state']),
        @process['%cpu'].rjust(column_widths['%cpu']),
        @process['%mem'].rjust(column_widths['%mem']),
        @process['time'].rjust(column_widths['time']),
        @process['command']
      ].join('  ')[0..Curses.cols].ljust(Curses.cols)
    end

    def to_s
      @padded_row
    end
  end
end
