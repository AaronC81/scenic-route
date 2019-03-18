require 'gosu'
require_relative 'tiles/tile_manager'
require_relative 'entities/map'
require_relative 'entities/route'
require_relative 'entities/point'
require_relative 'ui/map_controller'
require_relative 'ui/controller_supervisor'

module ScenicRoute
  class Game < Gosu::Window
    def initialize
      super 800, 600
      
      UI::MapController.new(
        Entities::Map.new(Entities::Map::EXAMPLE_MAP, Tiles::TileManager.tile_set(:track)),
        Entities::Point.new(0, 0)
      )
    end 

    def draw
      UI::ControllerSupervisor.dispatch(:draw)
    end

    def button_down(id)
      # Dispatch depending on whether mouse or keyboard
      if id >= 256 && id <= 258
        UI::ControllerSupervisor.dispatch(:mouse_down, id,
          Entities::Point.new(mouse_x, mouse_y))
      else
        UI::ControllerSupervisor.dispatch(:button_down, id)
      end
    end

    def needs_cursor?
      true
    end
  end
end

ScenicRoute::Game.new.show