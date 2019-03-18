require_relative 'tile_object'

module ScenicRoute
  module Entities
    class LandmarkObject < TileObject
      attr_reader :kind

      def initialize(point, kind)
        super(point)

        @kind = kind
      end

      def tile_name
        "object_landmark_#{kind}".to_sym
      end

      def within_bonus_range?(query_point)
        delta_x = (query_point.x - point.x).abs
        delta_y = (query_point.y - point.y).abs

        delta_x <= 1 && delta_y <= 1
      end
    end
  end
end