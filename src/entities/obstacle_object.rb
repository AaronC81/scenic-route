require_relative 'tile_object'

module ScenicRoute
  module Entities
    ##
    # Represents an obstacle, which cannot have tracks placed through it. Since
    # {TileObject} instances can never have tracks placed through them anyway,
    # this is simply a non-functional object.
    class ObstacleObject < TileObject
      ##
      # @return [Symbol] A suffix for the image used for this obstacle.
      attr_reader :kind

      ##
      # Create a new obstacle.
      # @param [Point] point
      # @param [Symbol] kind 
      def initialize(point, kind)
        super(point)

        @kind = kind
      end

      ##
      # @return [Symbol] The tile name for this obstacle, which is a valid tile 
      #   in a world.
      def tile_name
        "object_obstacle_#{kind}".to_sym
      end
    end
  end
end