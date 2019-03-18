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

        # Check where we were on the map
        tile_x = (mouse_point.x - origin.x) / map.tile_set.width
        tile_y = (mouse_point.y - origin.y) / map.tile_set.height

        if tile_x >= 0 && tile_x <= map.width && tile_y >= 0 && tile_y <= map.height
          tile_point = Entities::Point.new(tile_x.to_i, tile_y.to_i)

          if @drawing
            map.place_track(tile_point)
          elsif @removing
            map.remove_track(tile_point)
          end

          tile_corner_x = tile_x.to_i * map.tile_set.width + origin.x
          tile_corner_y = tile_y.to_i * map.tile_set.height + origin.y
        
          Gosu.draw_rect(tile_corner_x, tile_corner_y, map.tile_set.width,
            map.tile_set.height, 0x77FFFF00, 10) # TODO Colour based on validity
        end
      end

      def button_down(id)
        super

        @drawing = true if id == Gosu::MsLeft
        @removing = true if id == Gosu::MsRight
      end

      def button_up(id)
        super

        @drawing = false if id == Gosu::MsLeft
        @removing = false if id == Gosu::MsRight
      end
    end
  end
end