require 'gosu'

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

        map_width = layout.first.length
        map_height = layout.length

        map_width.times do |mx|
          map_height.times do |my|
            this_tile = layout[my][mx]
            this_tile_x = tile_width * mx + start_x
            this_tile_y = tile_height * my + start_y
            tile_set.tile(this_tile).draw(this_tile_x, this_tile_y, z)
          end
        end
      end
    end 
  end
end