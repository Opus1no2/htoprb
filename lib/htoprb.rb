# frozen_string_literal: true

require_relative 'htoprb/version'

require 'curses'
require 'open3'
require 'htoprb/processes'
require 'htoprb/render'

module Htoprb
  class Error < StandardError; end

  def self.init
    Htoprb::Render.new.init
  rescue => exception
    p exception
  end
end
