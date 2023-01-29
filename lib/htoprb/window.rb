# frozen_string_literal: true

module Htoprb
  class Window
    attr_accessor :win

    def initialize(width = 0, height = 0, top = 0, left = 0)
      @win = Curses::Window.new(width, height, top, left)
      @win.scrollok(true)
      @win.setscrreg(Curses.lines, Curses.cols)
      @win.keypad(true)
      @win.timeout = 0
    end
  end
end
