require_relative 'tile_object'

module ScenicRoute
  module Entities
    class StationObject < TileObject
      attr_reader :orientation, :number

      def initialize(point, orientation, number)
        super(point)

        @orientation = orientation
        @number = number
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