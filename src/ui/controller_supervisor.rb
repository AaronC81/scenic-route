require 'set'
require_relative '../io/save_manager'

module ScenicRoute
  module UI
    ##
    # Controllers must register with this supervisor, which will then dispatch
    # event calls.
    class ControllerSupervisor
      ##
      # The set of currently registered {Controller} instances.
      @@controllers = Set[]

      ##
      # @return [Set<Controller>] The currently registered controllers.
      def self.controllers
        @@controllers
      end

      ##
      # Sets the global window instance. [Game] sets this to itself when 
      # instantiated.
      def self.window=(window)
        @@window = window
      end

      ##
      # @return [Gosu::Window] The global window instance.
      def self.window
        @@window
      end

      ##
      # Registers a controller with the supervisor.
      def self.register(controller)
        @@controllers << controller
      end

      ##
      # Removes a previous controller registration.
      def self.unregister(controller)
        @@controllers.delete(controller)
      end

      ##
      # Calls a method on all registered controllers, passing varargs to it.
      #
      # @param [Symbol] method_name
      def self.dispatch(method_name, *args)
        @@controllers.map { |c| c.send(method_name, *args) }
      end

      ##
      # Retrieves a controller instance by its type.
      #
      # @param [Symbol] type
      # @return [Controller]
      #
      # @raise [RuntimeError] If more than one instance of this controller type
      #   is registered, or if no controller of this type is registered. This
      #   shouldn't really happen anyway if everything is initialised through
      #   normal channels.
      def self.controller(type)
        matching = @@controllers.select { |x| x.is_a?(type) }
        raise 'not one controller of this type' if matching.length != 1
        matching.first
      end

      ##
      # Calls methods on the appropriate controllers to load a new map into the
      # game.
      #
      # @param [Entities::Map] map
      def self.load_map(map)
        ControllerSupervisor.controller(MapController).load(map)
        IO::SaveManager.load_map_state(map)
        ControllerSupervisor.controller(HudController).reset
      end
    end
  end
end