require_relative '../entities/map'
require_relative '../entities/point'
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
        @drawing = false
      end

      ##
      # Draws the map to the screen, and also draw any new track to the screen.
      def draw
        super

        map.draw(origin.x, origin.y, 1)

        if @drawing
          # Check where we were on the map
          tile_x = (mouse_point.x - origin.x) / map.tile_set.width
          tile_y = (mouse_point.y - origin.y) / map.tile_set.height

          if tile_x >= 0 && tile_x <= map.width && tile_y >= 0 && tile_y <= map.height
            map.place_track(Entities::Point.new(tile_x.to_i, tile_y.to_i))
          end
        end
      end

      def button_down(id)
        super

        @drawing = true if id == Gosu::MsLeft
      end

      def button_up(id)
        super

        @drawing = false if id == Gosu::MsLeft
      end
    end
  end
end
