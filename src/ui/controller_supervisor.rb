require 'set'

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
    end
  end
end