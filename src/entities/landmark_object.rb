require_relative 'tile_object'

module ScenicRoute
  module Entities
    ##
    # Represents a landmark, which gives bonus score to tracks within its range.
    class LandmarkObject < TileObject
      ##
      # @return [Symbol] A suffix for the image used for this landmark.
      attr_reader :kind

      ##
      # Create a new landmark.
      # @param [Point] point
      # @param [Symbol] kind 
      def initialize(point, kind)
        super(point)

        @kind = kind
      end

      ##
      # @return [Symbol] The tile name for this landmark, which is a valid tile
      #   in a world.
      def tile_name
        "object_landmark_#{kind}".to_sym
      end

      ##
      # Given a point, returns a boolean indicating whether a track at this 
      # point should be subject to a point bonus.
      # @param [Point] query_point
      # @return [Boolean]
      def within_bonus_range?(query_point)
        delta_x = (query_point.x - point.x).abs
        delta_y = (query_point.y - point.y).abs

        delta_x <= 1 && delta_y <= 1
      end
    end
  end
end