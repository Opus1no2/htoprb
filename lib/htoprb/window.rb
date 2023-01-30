# frozen_string_literal: true

module Htoprb
  class Window
    include Singleton

    attr_reader :win

    def initialize(height = 0, width = 0, top = 0, left = 0)
      @win = Curses::Window.new(height, width, top, left)
      @win.scrollok(true)
      @win.setscrreg(Curses.lines, Curses.cols)
      @win.keypad(true)
      @win.timeout = 0
    end
  end
end
