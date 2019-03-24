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
require_relative 'ui/particle_controller'
require_relative 'entities/particle'
require_relative 'entities/obstacle_object'
require_relative 'ui/dialogue_controller'
require_relative 'ui/menu_controller'

module ScenicRoute
  class Game < Gosu::Window
    WIDTH = 1280  
    HEIGHT = 720
    FPS = 60

    attr_reader :map

    def initialize
      super WIDTH, HEIGHT

      Gosu::enable_undocumented_retrofication
      
      UI::ControllerSupervisor.window = self

      @map = IO::MapLoader.load_map('res/levels/0.srlay', Tiles::TileManager.tile_set(:world))

      UI::MapController.new(nil)

      UI::DialogueController.new
      UI::BackgroundController.new
      UI::HudController.new
      UI::ParticleController.new
      
      UI::MenuController.new
    end 

    def draw
      UI::ControllerSupervisor.dispatch(:draw)
    end

    def update
      UI::ControllerSupervisor.dispatch(:update)
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