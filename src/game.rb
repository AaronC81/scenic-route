require 'gosu'
require_relative 'tiles/tile_manager'

module ScenicRoute
  class Game < Gosu::Window
    def initialize
      super 800, 600
    end 

    def draw
    end
  end
end

ScenicRoute::Game.new.show