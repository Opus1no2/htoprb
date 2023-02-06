# frozen_string_literal: true

module Htoprb
  class Process
    attr_reader :id, :str, :process

    def initialize(process, id, serializer = ProcessSerializer.instance)
      @id = id
      @str = ''
      @process = process
      @serializer = serializer
    end

    def generate_column_widths(column_widths)
      @str = @serializer.pad_row(@process, column_widths)
    end
  end
end
