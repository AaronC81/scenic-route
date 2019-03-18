require_relative 'controller_supervisor'

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
      # An event handler called when {Gosu::Window#draw} is called.
      def draw
      end

      ##
      # An event handler called when {Gosu::Window#button_down} is called, and
      # is not a mouse event.
      def button_down(id)
      end

      ##
      # An event handler called when {Gosu::Window#button_down} is called with
      # a mouse ID.
      def mouse_down(id, mouse_point)
      end
    end
  end
end