require_relative 'tile_object'

module ScenicRoute
  module Entities
    class StationObject < TileObject
      attr_reader :orientation

      def initialize(point, orientation)
        super(point)

        @orientation = orientation
      end

      def track_connectivity
        {
          north: false,
          east: false,
          west: false,
          south: false
        }.merge({orientation => true})
      end

      def tile_name
        "object_station_#{orientation}".to_sym
      end
    end
  end
end