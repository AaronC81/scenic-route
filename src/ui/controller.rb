require_relative 'controller_supervisor'
require_relative '../entities/point'

module ScenicRoute
  module UI
    ##
    # An abstract class representing something which needs to respond to game
    # events.
    class Controller
      ##
      # Create a new controller and register it with the controller supervisor
      # so that it receives events.
      def initialize
        ControllerSupervisor.register(self)
      end

      ##
      # @return [Entities::Point] The current mouse position, relative to the 
      #   window's top-left corner.
      def mouse_point
        Entities::Point.new(
          ControllerSupervisor.window.mouse_x,
          ControllerSupervisor.window.mouse_y
        )
      end

      ##
      # @return [Entities::Map] The currently loaded map.
      def map
        ControllerSupervisor.controller(MapController).map
      end

      ##
      # An event handler called when the Gosu window calls +#draw+.
      def draw
      end

      ##
      # An event handler called when the Gosu window calls +#update+.
      def update
      end

      ##
      # An event handler called when the Gosu window calls +#button_down+.
      def button_down(id)
      end

      ##
      # An event handler called when the Gosu window calls +#button_up+.
      def button_up(id)
      end
    end
  end
end