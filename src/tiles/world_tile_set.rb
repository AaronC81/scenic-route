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
        :scene_backdrop,
        :object_station_south,
        :object_station_north,
        :object_station_east,
        :object_station_west,
        :object_landmark_statue,
        :scene_edge_north,
        :scene_edge_south,
        :scene_corner_north_east,
        :scene_corner_north_west,
        :scene_edge_east,
        :scene_edge_west,
        :scene_corner_south_east,
        :scene_corner_south_west,
        :scene_concave_north_east,
        :scene_concave_north_west,
        :scene_concave_south_east,
        :scene_concave_south_west,
        :object_obstacle_tree,
        :scene_groove_begin_east,
        :scene_groove_begin_west,
        :scene_groove_horizontal,
        :scene_groove_end_west,
        :scene_groove_end_east,
        :scene_groove_begin_north,
        :scene_groove_begin_south,
        :scene_groove_vertical,
        :scene_groove_end_south,
        :scene_groove_end_north
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
      
      ##
      # Determines whether a tile can have a track placed over it.
      #
      # @param [String] name The tile.
      #
      # @return [Boolean] True if the tile can have a track placed over it, or
      #   false otherwise.
      def can_place_on?(name)
        name == :scene_ground
      end
    end
  end
end