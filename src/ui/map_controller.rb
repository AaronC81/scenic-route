require_relative '../entities/map'
require_relative 'controller'

module ScenicRoute
  module UI
    ##
    # Handles invocation of map-drawing methods and responds to track change
    # controls.
    class MapController < Controller
      ##
      # The map which this controller is associated with.
      attr_reader :map

      ##
      # The point at which this map should be drawn.
      attr_reader :origin

      ##
      # Create a new map controller.
      # 
      # @param [Entities::Map] map
      # @param [Entities::Point] origin
      def initialize(map, origin)
        super()

        @map = map
        @origin = origin
      end

      ##
      # Draws the map to the screen.
      def draw
        super

        map.draw(origin.x, origin.y, 1)
      end
    end
  end
end
