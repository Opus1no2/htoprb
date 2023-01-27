# frozen_string_literal: true

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
      @process_list.render
    rescue StandardError => e
      Curses.close_screen
      puts e.full_message
      puts e.backtrace.join("\n")
    end
  end
end
