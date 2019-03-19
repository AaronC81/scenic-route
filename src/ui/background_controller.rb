require 'gosu'
require_relative 'controller'

module ScenicRoute
  module UI
    ##
    # Handles drawing a background to the window.
    class BackgroundController < Controller
      def draw
        Gosu.draw_rect(0, 0, Game::WIDTH, Game::HEIGHT, 0xFFFFFFFF)
      end
    end
  end
end