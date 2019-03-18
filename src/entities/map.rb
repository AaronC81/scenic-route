require 'gosu'
require_relative 'point'
require_relative 'route'

module ScenicRoute
  module Entities
    ##
    # Represents a game map with routes drawn over it.
    class Map
      ##
      # An example map to demonstrate the layout required.
      EXAMPLE_MAP = [
        %I{water water water water water water water water},
        %I{water water grass grass grass grass water water},
        %I{water grass grass grass grass grass water water},
        %I{water water grass grass water grass water water},
        %I{water water grass water water grass grass water},
        %I{water water water water water water water water}
      ]

      ##
      # @return [Array<Array<Symbol>>] A 2D array (row, col) of this map's 
      #   fixed layout, where each element is a tile name. This does not change
      #   as routes are drawn; elements are replaced with tracks when the map is
      #   drawn.
      attr_reader :layout

      ##
      # @return [Array<Route>] An array of the routes on this track.
      attr_reader :routes

      ##
      # @return [Tiles::TileSet] The tile set with which this map is drawn.
      attr_reader :tile_set

      ## 
      # Create a new map.
      #
      # @param [Array<Array<Symbol>>] layout
      # @param [TileSet] tile_set
      def initialize(layout, tile_set)
        # TODO: validate maps
        @layout = layout
        @tile_set = tile_set
        @routes = []
      end

      ##
      # @return [Numeric] How many tiles wide this map is.
      def width
        layout.first.length
      end

      ##
      # @return [Numeric] How many tiles tall this map is.
      def height
        layout.length
      end

      ##
      # Place a track piece at a specific location, adjusing routes accordingly.
      #
      # @param [Point] point
      # @return [Boolean] True if the track piece was inserted, false otherwise.
      #
      # @raise [ArgumentError] If the point already exists in a route.
      def place_track(point)
        # TODO: check map bounds

        inserted = false
        routes.each do |route|
          # Ensure this point doesn't already exist in a route
          return false if route.points.include?(point)

          # If this point fits at either end of an existing route, add it and
          # leave the function
          if route.points.first.adjacent_to?(point)
            route.points.insert(0, point)
            inserted = true
            break
          elsif route.points.last.adjacent_to?(point)
            route.points << point
            inserted = true
            break
          end
        end

        # There was no existing route to integrate the point into; create a new
        # one instead
        routes << Route.new(self, [point]) unless inserted

        # If two paths ran into each other, we should join them
        routes.each do |a|
          routes.each do |b|
            if a != b && a.adjacent_to?(b)
              routes.delete(a)
              routes.delete(b)
              routes << a.join(b)
            end
          end
        end

        true
      end

      ## 
      # Draw this map and its routes onto the Gosu window.
      #
      # @param [Numeric] start_x The x position at which to start the map.
      # @param [Numeric] start_y The y position at which to start the map.
      # @param [Numeric] z The z position at which to draw the map.
      def draw(start_x, start_y, z)
        tile_set = Tiles::TileManager.tile_set(:track)

        route_tile_maps = routes.map(&:to_tile_hash).reduce(&:merge) || {}

        width.times do |mx|
          height.times do |my|
            if route_tile_maps[Point.new(mx, my)].nil?
              # Draw the map background
              this_tile = layout[my][mx]
            else
              # Draw a route tile
              this_tile = route_tile_maps[Point.new(mx, my)]
            end

            this_tile_x = tile_set.width * mx + start_x
            this_tile_y = tile_set.height * my + start_y
            tile_set.tile(this_tile).draw(this_tile_x, this_tile_y, z)
          end
        end
      end
    end 
  end
end