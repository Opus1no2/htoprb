# frozen_string_literal: true

require_relative 'htoprb/version'

require 'curses'
require 'open3'
require 'htoprb/platform'
require 'htoprb/linux'
require 'htoprb/darwin'
require 'htoprb/process'
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
end
