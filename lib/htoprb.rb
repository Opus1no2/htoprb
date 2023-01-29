# frozen_string_literal: true

require_relative 'htoprb/version'

require 'curses'
require 'open3'
require 'singleton'
require 'htoprb/platform'
require 'htoprb/linux'
require 'htoprb/darwin'
require 'htoprb/process_serializer'
require 'htoprb/process'
require 'htoprb/process_list_base'
require 'htoprb/process_list'
require 'htoprb/render'

module Htoprb
  class Error < StandardError; end

  def self.init
    Htoprb::Render.new.init
  rescue StandardError => e
    puts e.full_message
    puts e.backtrace.join("\n")
  end

  def self.platform
    @platform ||= case os
                  when 'linux'
                    Htoprb::Linux.new
                  when 'darwin'
                    Htoprb::Darwin.new
                  else
                    raise StandardError, '[htoprb] - unsupported platform'
                  end
  end

  def self.os
    @os ||= Gem::Platform.local.os
  end
end
