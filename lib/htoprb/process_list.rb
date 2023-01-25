module Htoprb
  class ProcessList
    attr_accessor :start_idx, :win, :current, :processes, :timeout

    def initialize
      @start_idx = 0
      @current = 0
      @processes = []
      @needs_refresh = true
      @pause_refresh = false
      @timeout = 500

      Curses.start_color
      Curses.init_pair(1, 6, 0)

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
      stdout, stderr, wait_thr = Open3.capture3('ps', 'aux')
      stdout.split("\n")
    end

    def render
      @processes = running_processes

      old_time = Time.now

      loop do
        ch = @win.getch
        break if ch == 'q'

        new_time = Time.now

        if (new_time - old_time) * 1000.0 > @timeout
          @processes = running_processes
          @needs_refresh = true
          old_time = new_time
        end

        if ch == Curses::KEY_UP
          # This needs work
          if @start_idx.positive? && @processes.length > Curses.lines
            # @start_idx += -1
            # end_idx += -1
          end

          if @current.positive?
            @current += -1
            @needs_refresh = true
          end
        end

        if ch == Curses::KEY_DOWN
          # This needs work
          if end_idx < @processes.length && @processes.length > @win.maxy
            # @start_idx += 1
            # end_idx += 1
          end

          if @current < @processes.length - 1
            @current += 1
            @needs_refresh = true
          end
        end

        sleep(1.0 / 24.0) unless @needs_refresh || @pause_refresh

        refresh_process_list(@start_idx, end_idx) if @needs_refresh
      end
    end

    def refresh_process_list(start_idx, end_idx)
      @processes[start_idx..end_idx].each.with_index do |process, idx|
        @win.setpos(idx, 0)
        if idx == @current
          @win.attron(Curses.color_pair(1))
          @win.addstr(process)
          @win.attroff(Curses.color_pair(1))
        else
          @win.addstr(process)
        end
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
  end
end
