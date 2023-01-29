# frozen_string_literal: true

module Htoprb
  # TODO: separate process list logic from ncurses logic
  class ProcessList < ProcessListBase
    attr_reader :win, :timeout
    attr_accessor :needs_refresh, :moving

    def initialize(process = Process, window = Window.new)
      super(process)

      @start_idx = 1
      @current = 1
      @needs_refresh = true
      @moving = false
      @timeout = 1000 # make configurable
      @win = window.win
    end

    def init
      refresh_process_list
      render_header
    end

    def render_header
      @win.setpos(0, 0)
      @win.attron(Curses.color_pair(2))
      @win << @process_list.first.str
      @win.attroff(Curses.color_pair(2))
    end

    def render_process_list
      @process_list[@start_idx..end_idx].each.with_index(1) do |process, idx|
        @win.setpos(idx, 0)

        if @current == process.id
          @win.attron(Curses.color_pair(1))
          @win << process.str
          @win.attroff(Curses.color_pair(1))
        else
          @win << process.str
        end

        @win.clrtoeol
      end

      @win.refresh
      @needs_refresh = false
    end

    def end_idx
      @end_idx ||= if @process_list.length >= Curses.lines
                     Curses.lines
                   else
                     @process_list.length - 1
                   end
    end

    def handle_key_up
      @moving = true

      return if @current == 1

      # This needs work
      if @start_idx.positive? && @process_list.length > Curses.lines
        # @start_idx += -1
        # end_idx += -1
      end

      @current += -1
      @needs_refresh = true
    end

    def handle_key_down
      @moving = true

      return if @current == @process_list.length - 1

      @current += 1

      # This needs work
      if end_idx < @process_list.length && @process_list.length > @win.maxy
        # @start_idx += 1
        # end_idx += 1
      end

      @needs_refresh = true
    end
  end
end
