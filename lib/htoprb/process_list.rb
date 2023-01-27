# frozen_string_literal: true

module Htoprb
  # TODO: separate process list logic from ncurses logic
  class ProcessList
    attr_accessor :start_idx, :win, :current, :processes, :timeout

    FRAMERATE = 1.0 / 24.0
    COLS = {
      'pid' => 'PID',
      'user' => 'USER',
      'pri' => 'PRI',
      'ni' => 'NI',
      'rss' => 'RES',
      'state' => 'S',
      '%cpu' => 'CPU%',
      '%mem' => 'MEM%',
      'etime' => 'Time',
      'command' => 'Command'
    }.freeze

    def initialize(process = Htoprb::Process)
      @start_idx = 0
      @current = 1
      @processes = []
      @needs_refresh = true
      @moving = false
      @timeout = 2000 # make configurable
      @column_widths = {}
      @process = process

      init_window
    end

    def init_window
      @win = Curses::Window.new(Curses.lines, Curses.cols, 0, 0)
      @win.scrollok(true)
      @win.setscrreg(Curses.lines, Curses.cols)
      @win.keypad(true)
      @win.timeout = 0
    end

    def running_processes
      stdout, _stderr, _wait_thr = Open3.capture3('ps', ps_options, column_names)
      stdout.split("\n")
    end

    def ps_options
      os = Gem::Platform.local.os

      case os
      when 'linux'
        'axo'
      when 'darwin'
        'axr -o'
      else
        raise Error, "unsupported platform os: #{os}"
      end
    end

    def column_names
      COLS.map { |k, v| "#{k}=#{v}" }.join(',')
    end

    def render
      @processes = running_processes
      calculate_column_widths(@processes)

      old_time = Time.now

      loop do
        ch = @win.getch

        break if ch == 'q'

        new_time = Time.now

        # This pauses the entire from updating while navigating via up/down arrows
        # In the future - this should pause the list but allow specific status to update
        old_time = new_time if @moving

        if (new_time - old_time) * 1000.0 > @timeout
          @processes = running_processes
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

        render_process_list(@start_idx, end_idx) if @needs_refresh
      end
    end

    def render_process_list(start_idx, end_idx)
      @processes[start_idx..end_idx].each.with_index do |process, idx|
        @win.setpos(idx, 0)

        p = @process.new(@win, process, @column_widths)
        p.selected = true if @current == idx
        p.header = true if idx.zero?
        p.render

        @win.clrtoeol
      end

      @win.refresh
      @needs_refresh = false
    end

    def end_idx
      @end_idx = if @processes.length > Curses.lines - 2
                   Curses.lines - 2
                 else
                   @processes.length - 1
                 end
    end

    def handle_key_up
      @moving = true

      # This needs work
      if @start_idx.positive? && @processes.length > Curses.lines
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
      if end_idx < @processes.length && @processes.length > @win.maxy
        # @start_idx += 1
        # end_idx += 1
      end

      return unless @current < @processes.length - 1

      @current += 1
      @needs_refresh = true
    end

    def calculate_column_widths(processes)
      @column_widths['pri'] = 2
      @column_widths['ni'] = 2
      @column_widths['user'] = 10
      @column_widths['%cpu'] = 5
      @column_widths['%mem'] = 5
      @column_widths['state'] = 3
      @column_widths['time'] = 8

      max_pid = processes[1..].map { |process| process.split[0] }.max_by(&:length).length.to_i
      max_res = processes[1..].map { |process| process.split[4] }.max_by(&:length).length.to_i

      @column_widths['pid'] = max_pid
      @column_widths['rss'] = max_res
    end
  end
end
