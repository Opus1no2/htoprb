# frozen_string_literal: true

module Htoprb
  class Process
    attr_accessor :win, :process, :column_widths, :selected, :header

    def initialize(win, process, column_widths)
      @win = win
      @process = process
      @column_widths = column_widths
      @selected = false
      @header = false
      @selected = false

      Curses.start_color
      Curses.init_pair(1, 0, 6)
      Curses.init_pair(2, 0, 2)
    end

    def create_process_string
      process_parts = @process.split(' ')

      pid   = process_parts[0].rjust(column_widths['pid'])
      user  = process_parts[1][0..column_widths['user']].ljust(column_widths['user'] + 1)
      pri   = process_parts[2].rjust(column_widths['pri'])
      ni    = process_parts[3].rjust(column_widths['ni'])
      rss   = process_parts[4].rjust(column_widths['rss'])
      state = process_parts[5].rjust(column_widths['state'])
      cpu   = process_parts[6].rjust(column_widths['%cpu'])
      mem   = process_parts[7].rjust(column_widths['%mem'])
      time  = process_parts[8].rjust(column_widths['time'])

      command = process_parts[9]

      "#{pid}  #{user}  #{pri}  #{ni}  #{rss}  #{state}  #{cpu}  #{mem}  #{time}  #{command}"[0..Curses.cols - 1].ljust(Curses.cols)
    end

    def render
      process_str = create_process_string

      if header?
        @win.attron(Curses.color_pair(2))
        @win.addstr(process_str)
        @win.attroff(Curses.color_pair(2))
        return
      end

      if selected?
        @win.attron(Curses.color_pair(1))
        @win.addstr(process_str)
        @win.attroff(Curses.color_pair(1))
        return
      end

      @win.addstr(process_str)
    end

    def header?
      @header
    end

    def selected?
      @selected
    end
  end
end
