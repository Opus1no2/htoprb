# frozen_string_literal: true

module Htoprb
  # TODO: separate process list logic from ncurses logic
  class ProcessList < ProcessListBase
    attr_reader :win, :timeout, :header_stats
    attr_accessor :needs_refresh, :moving

    def initialize(header, process = Process, window = Window.instance)
      super(process)

      @start_idx = 10
      @current = 10
      @needs_refresh = true
      @moving = false
      @timeout = 1000 # make configurable

      @win = window.win
      @header = header

      # clean this up
      @column_header_y = @header.height + 1
      @process_list_y  = @column_header_y + 1
    end

    def init
      refresh_process_list
      update_header_stats
      render_column_header
    end

    def update_header_stats
      @header.total_tasks = @process_list.length
    end

    def render_column_header
      @win.setpos(@column_header_y, 0)
      @win.attron(Curses.color_pair(Curses::COLOR_GREEN))
      @win << @process_list.first.str
      @win.attroff(Curses.color_pair(Curses::COLOR_GREEN))
    end

    def render_process_list
      @process_list[@start_idx..end_idx].each.with_index(@process_list_y) do |process, idx|
        @win.setpos(idx, 0)

        if @current == process.id
          @win.attron(Curses.color_pair(Curses::COLOR_CYAN))
          @win << process.str
          @win.attroff(Curses.color_pair(Curses::COLOR_CYAN))
        else
          @win << process.str
        end

        @win.clrtoeol
      end

      @win.refresh
      @needs_refresh = false
    end

    def end_idx
      @end_idx ||= if @process_list.length >= @win.maxy - @header.height
                     @win.maxy - 2
                   else
                     @process_list.length - 1
                   end
    end

    def handle_key_up
      @moving = true

      return if @current == @process_list_y

      # This needs work
      if end_idx > (@process_list.length - 2) - @process_list_y
        # @start_idx += -1
        # @end_idx += -1
      end

      @current += -1
      @needs_refresh = true
    end

    def handle_key_down
      @moving = true

      return if @current == @process_list.length - 2

      if (@current + 1 > Curses.lines - 2) && (@process_list.length >= Curses.lines - 2)
        @start_idx += 1
        @end_idx += 1
      end

      @current += 1

      @needs_refresh = true
    end
  end
end
