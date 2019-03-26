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
require_relative 'ui/transition_controller'

module ScenicRoute
  ##
  # The main game.
  class Game < Gosu::Window
    ##
    # The width of the game window.
    WIDTH = 1280  

    ##
    # The height of the game window.
    HEIGHT = 720

    ##
    # The frames-per-second at which the game should run.
    FPS = 60

    ##
    # Create a new game window and show it.
    def initialize
      super WIDTH, HEIGHT

      Gosu::enable_undocumented_retrofication
      
      UI::ControllerSupervisor.window = self

      IO::MapLoader.load_map('res/levels/0.srlay', Tiles::TileManager.tile_set(:world))

      UI::MapController.new(nil)

      UI::DialogueController.new
      UI::BackgroundController.new
      UI::HudController.new
      UI::ParticleController.new
      
      UI::MenuController.new
      UI::TransitionController.new
    end 

    ##
    # Invoked by Gosu each frame, which is usually {FPS} times per second but
    # may not be if slowdown occurs. Dispatches the :draw event to all
    # controllers.
    def draw
      UI::ControllerSupervisor.dispatch(:draw)
    end

    ##
    # Invoked by Gosu {FPS} times per second. Dispatches the :update event to
    # all controllers.
    def update
      UI::ControllerSupervisor.dispatch(:update)
    end

    ##
    # Invoked by Gosu when any button is pressed. Dispatches the :button_down  
    # event to all controllers.
    def button_down(id)
      UI::ControllerSupervisor.dispatch(:button_down, id)
    end

    ##
    # Invoked by Gosu when any button is released. Dispatches the :button_up  
    # event to all controllers.
    def button_up(id)
      UI::ControllerSupervisor.dispatch(:button_up, id)
    end

    ##
    # @return [Boolean] True, to ensure the cursor is displayed by Gosu at all
    #   times.
    def needs_cursor?
      true
    end
  end
end