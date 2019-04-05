require_relative 'tile_object'

module ScenicRoute
  module Entities
    ##
    # Represents a station which is at either end of a route.
    class StationObject < TileObject
      ##
      # The background colours which will be used by each station's scorecard.
      BACKGROUND_COLORS = {
        1 => 0xFF0000FF,
        2 => 0xFFFF0000,
        3 => 0xFF00FF00
      }

      ##
      # The text colours which will be used by each station's scorecard.
      TEXT_COLORS = {
        1 => 0xFFFFFFFF,
        2 => 0xFFFFFFFF,
        3 => 0xFF000000
      }

      ##
      # The text colours which will be used by each station's scorecard, if the 
      # score is no longer current.
      INACTIVE_TEXT_COLORS = {
        1 => 0xFF808080,
        2 => 0xFF808080,
        3 => 0xFF808080
      }

      ##
      # @return [Symbol] The compass heading in which this station's opening is
      #   oriented.
      attr_reader :orientation

      ##
      # @return [Integer] This station's number. A station may only be connected
      #   to its matching one with the same number. This is used as a key to
      #   {TEXT_COLORS}, {BACKGROUND_COLORS} etc.
      attr_reader :number

      ##
      # Create a new station.
      # @param [Point] point
      # @param [Symbol] orientation
      # @param [Integer] number
      def initialize(point, orientation, number)
        super(point)

        @orientation = orientation
        @number = number
      end

      ##
      # @return [Hash] A hash describing how this object may connect to tracks.
      #   A station may only connect on its open end.
      def track_connectivity
        {
          north: false,
          east: false,
          west: false,
          south: false
        }.merge({orientation => true})
      end

      ##
      # @return [Symbol] The tile name for this station, which is a valid tile
      #   in a world.
      def tile_name
        "object_station_#{orientation}".to_sym
      end
    end
  end
end