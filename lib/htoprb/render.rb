module Htoprb
  class Render
    include Curses

    attr_accessor :processes, :curses

    def initialize(processes = Htoprb::Processes)
      @processes = processes
    end

    def init
      init_screen
      nl
      noecho
      curs_set 0
      #stdscr.scrollok(true)
      #setscrreg(100, 100)

      begin
        loop do
          running = processes.call
          setpos(0, 0)
          addstr("Tasks #{running.total}")
          refresh

          running.processes.each.with_index do |p, idx|
            setpos(idx + 1, 0)
            addstr(p[0..50])
            refresh
          end

          sleep 1
        end
      rescue => exception
        Curses.close_screen
        raise exception
      end
    end
  end
end
