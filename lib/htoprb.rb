# frozen_string_literal: true

require_relative 'htoprb/version'

require 'curses'
require 'open3'
require 'htoprb/process'
require 'htoprb/process_list'
require 'htoprb/render'

module Htoprb
  class Error < StandardError; end

  def self.init
    Htoprb::Render.new.init
  rescue StandardError => e
    e.backtrace
  end
end
