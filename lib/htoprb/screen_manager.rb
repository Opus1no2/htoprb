# frozen_string_literal: true

module Htoprb
  class ScreenManager
    include Curses

    FRAMERATE = 1.0 / 24.0

    attr_reader :process_list

    def initialize(process_list = ProcessList,
                   header = Header)

      @timeout = 1500 # make configurable
      @header = header.new
      @process_list = process_list.new(@header)

      noecho
      crmode
      curs_set(0)
      stdscr.scrollok(true)

      start_color
      init_pair(COLOR_CYAN, COLOR_BLACK, COLOR_CYAN)
      init_pair(COLOR_GREEN, COLOR_BLACK, COLOR_GREEN)

      init_screen
    end

    def init
      @process_list.init
      @header.update_stats

      old_time = Time.now

      loop do
        ch = process_list.win.getch

        break if ch == 'q'

        new_time = Time.now

        # This pauses the entire from updating while navigating via up/down arrows
        # In the future - this should pause the list but allow specific status to update
        old_time = new_time if process_list.moving

        if (new_time - old_time) * 1000.0 > @timeout
          process_list.refresh_process_list
          process_list.needs_refresh = true
          old_time = new_time
        end

        case ch
        when Curses::KEY_UP
          process_list.handle_key_up
        when Curses::KEY_DOWN
          process_list.handle_key_down
        when nil
          process_list.moving = false
        end

        sleep(FRAMERATE) unless process_list.needs_refresh

        if process_list.needs_refresh
          process_list.render_process_list
          process_list.update_header_stats
        end
      end
    end
  end
end
