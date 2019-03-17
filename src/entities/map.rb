require 'gosu'
require_relative 'point'

module ScenicRoute
  module Entities
    class Map
      EXAMPLE_MAP = [
        %I{water water water water water water water water},
        %I{water water grass grass grass grass water water},
        %I{water grass grass grass grass grass water water},
        %I{water water grass grass water grass water water},
        %I{water water grass water water grass grass water},
        %I{water water water water water water water water}
      ]

      attr_reader :layout, :routes

      def initialize(layout)
        # TODO: validate maps
        @layout = layout
        @routes = []
      end

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