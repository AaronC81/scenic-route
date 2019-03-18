require_relative "tile_set"

module ScenicRoute
  module Tiles
    ##
    # A tile set which contains sufficient tiles for drawing a world with a
    # track and trains.
    class WorldTileSet < TileSet
      ##
      # The tiles which are required to be part of this tile set's definitions.
      # Metaprogrammatically generated methods are available, with these symbols
      # as names, to fetch each symbol.
      REQUIRED_SYMBOLS = [
        :track_south_east_bend,
        :track_north_west_bend,
        :track_north_east_bend,
        :track_south_west_bend,
        :track_intersection,
        :track_vertical_straight_on_ground,
        :track_horizontal_straight_on_ground,
        :scene_ground,
        :scene_backdrop
      ]

      REQUIRED_SYMBOLS.each do |sym|
        define_method(sym) do
          tile(sym)
        end
      end

      def initialize(*args)
        super

        raise ArgumentError, 'missing required tile def' unless valid?
      end

      ##
      # Ensures that all tiles which a {Map} would expect of tile set are
      # present.
      #
      # @return [Boolean] True if the tile definitions are valid, false
      #    otherwise.
      def valid?
        REQUIRED_SYMBOLS.all? { |sym| tile_definitions.include?(sym) }
      end
      
      def can_place_on?(name)
        name == :scene_ground
      end
    end
  end
end