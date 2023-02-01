# frozen_string_literal: true

module Htoprb
  class Window < SimpleDelegator
    include Singleton

    attr_reader :win

    def initialize(height = 0, width = 0, top = 0, left = 0)
      @win = Curses::Window.new(height, width, top, left)
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
