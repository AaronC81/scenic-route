require 'gosu'
require_relative 'tiles/tile_manager'
require_relative 'entities/map'
require_relative 'entities/route'
require_relative 'entities/point'
require_relative 'ui/map_controller'
require_relative 'ui/controller_supervisor'
require_relative 'io/map_loader'
require_relative 'entities/station_object'
require_relative 'gameplay/scoring'
require_relative 'entities/landmark_object'
require_relative 'ui/background_controller'
require_relative 'ui/hud_controller'

module ScenicRoute
  class Game < Gosu::Window
    WIDTH = 1280
    HEIGHT = 720

    attr_reader :map

    def initialize
      super WIDTH, HEIGHT
      
      UI::ControllerSupervisor.window = self

      @map = IO::MapLoader.load_map('res/layout/test.srlay', Tiles::TileManager.tile_set(:world))

      UI::MapController.new(
        map,
        Entities::Point.new(
          (WIDTH - map.pixel_width) / 2,
          (HEIGHT - map.pixel_height) / 2
        )
      )

      UI::BackgroundController.new
      UI::HudController.new(map)
    end 

    def draw
      UI::ControllerSupervisor.dispatch(:draw)
    end

    def button_down(id)
      UI::ControllerSupervisor.dispatch(:button_down, id)
    end

    def button_up(id)
      UI::ControllerSupervisor.dispatch(:button_up, id)
    end

    def needs_cursor?
      true
    end
  end
end

ScenicRoute::Game.new.show