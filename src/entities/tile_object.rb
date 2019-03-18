module ScenicRoute
  module Entities
    ##
    # An object which occupies a tile space, overriding the way that the tile
    # is drawn and defining additional behaviour.
    class TileObject
      ##
      # @return [Point] The tile at which this object is positioned.
      attr_reader :point

      ##
      # Create a new tile object. Not designed for direct use.
      #
      # @param [Point] point
      def initialize(point)
        @point = point
      end

      ##
      # @return [Hash] A hash of bearings to booleans, where true indicates
      #   that a track may connect to that side of the object.
      def track_connectivity
        {
          north: false,
          east: false,
          west: false,
          south: false
        }
      end

      ##
      # @return [Symbol] The tile which this object should be drawn as, from a
      #   {Tiles::WorldTileSet}.
      def tile_name
        nil
      end
    end
  end
end