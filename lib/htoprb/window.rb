# frozen_string_literal: true

module Htoprb
  class Window < SimpleDelegator
    include Singleton

    attr_reader :win

    def initialize
      @win = Curses::Window.new(0, 0, 0, 0)
      @win.scrollok(true)
      @win.setscrreg(Curses.lines, Curses.cols)
      @win.keypad(true)
      @win.timeout = 0

      super(@win)
    end

    def add_str(str, color = nil)
      return @win << str if color.nil?

      @win.attron(Curses.color_pair(color))
      @win << str
      @win.attroff(Curses.color_pair(color))
    end
  end
end
