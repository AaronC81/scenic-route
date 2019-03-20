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

      def mouse_point
        Entities::Point.new(
          ControllerSupervisor.window.mouse_x,
          ControllerSupervisor.window.mouse_y
        )
      end

      ##
      # An event handler called when {Gosu::Window#draw} is called.
      def draw
      end

      ##
      # An event handler called when {Gosu::Window#update} is called.
      def update
      end

      ##
      # An event handler called when {Gosu::Window#button_down} is called, and
      # is not a mouse event.
      def button_down(id)
      end

      ##
      # An event handler called when {Gosu::Window#button_up} is called, and
      # is not a mouse event.
      def button_up(id)
      end
    end
  end
end