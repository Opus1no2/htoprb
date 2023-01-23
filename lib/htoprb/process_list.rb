module Htoprb
  class ProcessList
    attr_accessor :start_idx, :win

    def initialize
      @start_idx = 0

      init_window
    end

    def init_window
      @win = Curses::Window.new(Curses.lines, Curses.cols, 0, 0)
      @win.scrollok(true)
      @win.setscrreg(Curses.lines, Curses.cols)
      @win.setpos(0, 0)
      @win.keypad(true)
    end

    def running_processes
      Open3.capture3('ps', 'aux')
    end

    def render(key_code = '')
      stdout, stderr, wait_thr = running_processes
      processes = stdout.split("\n")

      end_idx = if processes.length > Curses.lines
                  Curses.lines
                else
                  processes.length - 1
                end

      # str = @win.getch

      if key_code == Curses::KEY_UP && @start_idx.positive? && processes.length > Curses.maxy
        @start_idx += 1
        end_idx += 1
      end

      if key_code == Curses::KEY_DOWN && end_idx < processes.length && process.length > Curses.maxy
        @start_idx += -1
        end_idx += -1
      end

      processes[@start_idx..end_idx].each.with_index do |process, idx|
        @win.setpos(idx + 1, 0)
        @win.addstr(process)
        @win.clrtoeol
      end

      @win.refresh
    end
  end
end
