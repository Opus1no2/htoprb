# frozen_string_literal: true

module Htoprb
  # TODO: separate process list logic from ncurses logic
  class ProcessList
    attr_reader :win, :timeout, :header_stats
    attr_accessor :needs_refresh, :moving

    def initialize(header,
                   process = Process,
                   window = Window.instance,
                   serializer = ProcessSerializer.instance)

      @needs_refresh = true
      @moving = false
      @timeout = 1000 # make configurable

      @process = process
      @win = window.win
      @header = header
      @serializer = serializer

      # clean this up
      @column_header_y = @header.height + 1
      @process_list_y  = @column_header_y + 1

      @start_idx = @process_list_y
      @current = @process_list_y
    end

    def init
      refresh_process_list
      update_header_stats
      render_column_header
    end

    def update_header_stats
      @header.total_tasks = @process_list.length
    end

    def render_column_header
      @win.setpos(@column_header_y, 0)
      @win.attron(Curses.color_pair(Curses::COLOR_GREEN))
      @win << @process_list.first.str
      @win.attroff(Curses.color_pair(Curses::COLOR_GREEN))
    end

    def render_process_list
      @process_list[@start_idx..end_idx].each.with_index(@process_list_y) do |process, idx|
        @win.setpos(idx, 0)

        if @current == process.id
          @win.attron(Curses.color_pair(Curses::COLOR_CYAN))
          @win << process.str
          @win.attroff(Curses.color_pair(Curses::COLOR_CYAN))
        else
          @win << process.str
        end

        @win.clrtoeol
      end

      @win.refresh
      @needs_refresh = false
    end

    def platform
      @platform ||= Htoprb.platform
    end

    def refresh_process_list
      @process_list = @serializer
                      .serialized_processes(platform.process_list)
                      .map.with_index do |proc, id|
        @process.new(proc, id)
      end

      @process_list.each do |process|
        process.generate_column_widths(column_widths)
      end

      @process_list
    end

    def default_column_widths
      {
        'pri' => 2,
        'ni' => 2,
        'user' => 10,
        '%cpu' => 5,
        '%mem' => 5,
        'state' => 3,
        'time' => 8
      }
    end

    def column_widths
      default_column_widths.merge('pid' => max_pid, 'rss' => max_res)
    end

    def max_pid
      @process_list[1..].map { |p| p.process['pid'] }.max_by(&:length).length
    end

    def max_res
      @process_list[1..].map { |p| p.process['rss'] }.max_by(&:length).length
    end

    def end_idx
      @end_idx ||= if @process_list.length >= @win.maxy - @header.height
                     @win.maxy - 2
                   else
                     @process_list.length - 1
                   end
    end

    def handle_key_up
      @moving = true

      return if @current == @process_list_y

      # This needs work
      if end_idx > (@process_list.length - 2) - @process_list_y
        # @start_idx += -1
        # @end_idx += -1
      end

      @current += -1
      @needs_refresh = true
    end

    def handle_key_down
      @moving = true

      return if @current == @process_list.length - 2

      if (@current + 1 > Curses.lines - 2) && (@process_list.length >= Curses.lines - 2)
        @start_idx += 1
        @end_idx += 1
      end

      @current += 1

      @needs_refresh = true
    end
  end
end
