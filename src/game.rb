require 'gosu'
require_relative 'tiles/tile_manager'
require_relative 'entities/map'
require_relative 'entities/route'
require_relative 'entities/point'
require_relative 'controllers/map_controller'
require_relative 'controllers/controller_supervisor'
require_relative 'io/map_loader'
require_relative 'entities/station_object'
require_relative 'gameplay/scoring'
require_relative 'entities/landmark_object'
require_relative 'controllers/background_controller'
require_relative 'controllers/hud_controller'
require_relative 'controllers/particle_controller'
require_relative 'entities/particle'
require_relative 'entities/obstacle_object'
require_relative 'controllers/dialogue_controller'
require_relative 'controllers/menu_controller'
require_relative 'controllers/transition_controller'

module ScenicRoute
  ##
  # The main game.
  class Game < Gosu::Window
    ##
    # A hash of the command-line options the game was run with.
    OPTIONS = ARGV.join(' ').scan(/--?([^=\s]+)(?:=(\S+))?/).to_h

    ##
    # The virtual width of the game window. This is not necessarily the same
    # as the current resolution width.
    WIDTH = 1280  

    ##
    # The virtual height of the game window. This is not necessarily the same
    # as the current resolution height.
    HEIGHT = 720

    ##
    # The resolution width of the window.
    ACTUAL_WIDTH = (OPTIONS['width'] || 1920).to_i

    ##
    # The resolution height of the window.
    ACTUAL_HEIGHT = (OPTIONS['height'] || 1080).to_i

    ##
    # Whether to make the window fullscreen.
    FULLSCREEN = !(OPTIONS['fullscreen'] == 'false')

    ##
    # The frames-per-second at which the game should run.
    FPS = 60

    ##
    # Create a new game window and show it.
    def initialize
      super ACTUAL_WIDTH, ACTUAL_HEIGHT, fullscreen: FULLSCREEN

      Gosu::enable_undocumented_retrofication
      
      Controllers::ControllerSupervisor.window = self

      Controllers::MapController.new(nil)

      Controllers::DialogueController.new
      Controllers::BackgroundController.new
      Controllers::HudController.new
      Controllers::ParticleController.new
      
      Controllers::MenuController.new
      Controllers::TransitionController.new
    end 

    ##
    # @return [Numeric] The drawing scale factor for width.
    def width_scaling
      ACTUAL_WIDTH.to_f / WIDTH
    end

    ##
    # @return [Numeric] The drawing scale factor for height.
    def height_scaling
      ACTUAL_HEIGHT.to_f / HEIGHT
    end

    ##
    # Invoked by Gosu each frame, which is usually {FPS} times per second but
    # may not be if slowdown occurs. Dispatches the :draw event to all
    # controllers.
    def draw
      scale(width_scaling, height_scaling, 0, 0) do
        Controllers::ControllerSupervisor.dispatch(:draw)
      end
    end

    ##
    # Invoked by Gosu {FPS} times per second. Dispatches the :update event to
    # all controllers.
    def update
      Controllers::ControllerSupervisor.dispatch(:update)
    end

    ##
    # Invoked by Gosu when any button is pressed. Dispatches the :button_down  
    # event to all controllers.
    def button_down(id)
      Controllers::ControllerSupervisor.dispatch(:button_down, id)
    end

    ##
    # Invoked by Gosu when any button is released. Dispatches the :button_up  
    # event to all controllers.
    def button_up(id)
      Controllers::ControllerSupervisor.dispatch(:button_up, id)
    end

    ##
    # @return [Boolean] True, to ensure the cursor is displayed by Gosu at all
    #   times.
    def needs_cursor?
      true
    end
  end
end