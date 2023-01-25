module Htoprb
  class Render
    include Curses

    attr_accessor :process_list, :curses

    def initialize(process_list = Htoprb::ProcessList.new)
      @process_list = process_list

      noecho
      crmode
      curs_set(0)
      stdscr.scrollok(true)
      init_screen
    end

    def init
      begin
        @process_list.render
      rescue => exception
        Curses.close_screen
        p exception
      end
    end
  end
end
