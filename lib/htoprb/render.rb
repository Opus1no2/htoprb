module Htoprb
  class Render
    include Curses

    attr_accessor :process_list, :curses

    def initialize(process_list = Htoprb::ProcessList.new)
      @process_list = process_list

      noecho
      curs_set(0)
      crmode
    end

    def init
      init_screen
      stdscr.scrollok(true)

      begin
        loop do
          @process_list.render

          sleep 1
        end
      rescue => exception
        Curses.close_screen
        p exception
      end
    end
  end
end
