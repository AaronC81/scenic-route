require_relative 'tile_object'

module ScenicRoute
  module Entities
    class ObstacleObject < TileObject
      attr_reader :kind

      def initialize(point, kind)
        super(point)

        @kind = kind
      end

      def tile_name
        "object_obstacle_#{kind}".to_sym
      end
    end
  end
end