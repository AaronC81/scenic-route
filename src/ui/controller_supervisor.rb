require 'set'
require_relative '../io/save_manager'

module ScenicRoute
  module UI
    ##
    # Controllers must register with this supervisor, which will then dispatch
    # event calls.
    class ControllerSupervisor
      @@controllers = Set[]

      def self.controllers
        @@controllers
      end

      def self.window=(window)
        @@window = window
      end

      def self.window
        @@window
      end

      def self.register(controller)
        @@controllers << controller
      end

      def self.unregister(controller)
        @@controllers.delete(controller)
      end

      def self.dispatch(method_name, *args)
        @@controllers.map { |c| c.send(method_name, *args) }
      end

      def self.controller(type)
        matching = @@controllers.select { |x| x.is_a?(type) }
        raise 'not one controller of this type' if matching.length != 1
        matching.first
      end

      def self.load_map(map)
        ControllerSupervisor.controller(MapController).load(map)
        IO::SaveManager.load_map_state(map)
        ControllerSupervisor.controller(HudController).reset
      end
    end
  end
end