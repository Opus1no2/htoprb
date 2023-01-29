# frozen_string_literal: true

module Htoprb
  class ProcessSerializer
    include Singleton

    def serialized_processes(processes)
      processes.map do |line|
        process = line.split

        {
          'pid' => process[0],
          'user' => process[1],
          'pri' => process[2],
          'ni' => process[3],
          'rss' => process[4],
          'state' => process[5],
          '%cpu' => process[6],
          '%mem' => process[7],
          'time' => process[8],
          'command' => process[9..].join(' ') # only works if command is last
        }
      end
    end

    def pad_row(process, column_widths)
      [
        process['pid'].rjust(column_widths['pid']),
        process['user'][0..column_widths['user']].ljust(column_widths['user'] + 1),
        process['pri'].rjust(column_widths['pri']),
        process['ni'].rjust(column_widths['ni']),
        process['rss'].rjust(column_widths['rss']),
        process['state'].rjust(column_widths['state']),
        process['%cpu'].rjust(column_widths['%cpu']),
        process['%mem'].rjust(column_widths['%mem']),
        process['time'].rjust(column_widths['time']),
        process['command']
      ].join('  ')[0..Curses.cols].ljust(Curses.cols)
    end
  end
end
