# frozen_string_literal: true

module Htoprb
  # TODO: separate process list logic from ncurses logic
  class ProcessList < ProcessListBase
    FRAMERATE = 1.0 / 24.0

    def initialize(process = Process)
      super(process)

      @start_idx = 1
      @current = 0
      @needs_refresh = true
      @moving = false
      @timeout = 1000 # make configurable
      @column_widths = {}
      @process_list = []

      init_window

      Curses.start_color
      Curses.init_pair(1, 0, 6)
      Curses.init_pair(2, 0, 2)
    end

    def init_window
      @win = Curses::Window.new(Curses.lines, Curses.cols, 0, 0)
      @win.scrollok(true)
      @win.setscrreg(Curses.lines, Curses.cols)
      @win.keypad(true)
      @win.timeout = 0
    end

    def hydrate_process_list
      @process_list = process_list
    end

    def render
      hydrate_process_list
      calculate_column_widths

      old_time = Time.now

      loop do
        ch = @win.getch

        break if ch == 'q'

        new_time = Time.now

        # This pauses the entire from updating while navigating via up/down arrows
        # In the future - this should pause the list but allow specific status to update
        old_time = new_time if @moving

        if (new_time - old_time) * 1000.0 > @timeout
          hydrate_process_list
          @needs_refresh = true
          old_time = new_time
        end

        case ch
        when Curses::KEY_UP
          handle_key_up
        when Curses::KEY_DOWN
          handle_key_down
        when nil
          @moving = false
        end

        sleep(FRAMERATE) unless @needs_refresh

        render_process_list if @needs_refresh
      end
    end

    def render_header
      @win.setpos(0, 0)
      @win.attron(Curses.color_pair(2))
      @win << @process_list.first.column_str(@column_widths)
      @win.attroff(Curses.color_pair(2))
    end

    def render_process_list
      render_header

      @process_list[@start_idx..end_idx].each.with_index do |process, idx|
        @win.setpos(idx + 1, 0)

        if @current == idx
          @win.attron(Curses.color_pair(1))
          @win << process.column_str(@column_widths)
          @win.attroff(Curses.color_pair(1))
        else
          @win << process.column_str(@column_widths)
        end

        @win.clrtoeol
      end

      @win.refresh
      @needs_refresh = false
    end

    def end_idx
      if @process_list.length > Curses.lines - 2
        Curses.lines - 2
      else
        @process_list.length - 1
      end
    end

    def handle_key_up
      @moving = true

      # This needs work
      if @start_idx.positive? && @process_list.length > Curses.lines
        # @start_idx += -1
        # end_idx += -1
      end

      return unless @current.positive?

      @current += -1
      @needs_refresh = true
    end

    def handle_key_down
      @moving = true

      # This needs work
      if end_idx < @process_list.length && @process_list.length > @win.maxy
        # @start_idx += 1
        # end_idx += 1
      end

      return unless @current < @process_list.length - 1

      @current += 1
      @needs_refresh = true
    end

    def calculate_column_widths
      @column_widths['pri'] = 2
      @column_widths['ni'] = 2
      @column_widths['user'] = 10
      @column_widths['%cpu'] = 5
      @column_widths['%mem'] = 5
      @column_widths['state'] = 3
      @column_widths['time'] = 8

      @column_widths['pid'] = max_pid
      @column_widths['rss'] = max_res
    end

    def max_pid
      @process_list[1..].map { |p| p.process['pid'] }.max_by(&:length).length
    end

    def max_res
      @process_list[1..].map { |p| p.process['rss'] }.max_by(&:length).length
    end
  end
end
