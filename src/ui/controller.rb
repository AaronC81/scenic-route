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
    end
  end
end