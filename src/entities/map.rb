require 'gosu'
require_relative 'point'

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
      # Create a new map.
      #
      # @param [Array<Array<Symbol>>] layout
      def initialize(layout)
        # TODO: validate maps
        @layout = layout
        @routes = []
      end

      ## 
      # Draw this map and its routes onto the Gosu window.
      #
      # @param [Numeric] start_x The x position at which to start the map.
      # @param [Numeric] start_y The y position at which to start the map.
      # @param [Numeric] z The z position at which to draw the map.
      def draw(start_x, start_y, z)
        # TODO: store tile width and height in TileSet instead
        tile_width = 64
        tile_height = 64
        tile_set = Tiles::TileManager.tile_set(:track)

        route_tile_maps = routes.map(&:to_tile_hash).reduce(&:merge) || {}

        map_width = layout.first.length
        map_height = layout.length

        map_width.times do |mx|
          map_height.times do |my|
            if route_tile_maps[Point.new(mx, my)].nil?
              # Draw the map background
              this_tile = layout[my][mx]
            else
              # Draw a route tile
              this_tile = route_tile_maps[Point.new(mx, my)]
            end

            this_tile_x = tile_width * mx + start_x
            this_tile_y = tile_height * my + start_y
            tile_set.tile(this_tile).draw(this_tile_x, this_tile_y, z)
          end
        end
      end
    end 
  end
end