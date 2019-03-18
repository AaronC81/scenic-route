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
        "object_landmark_#{station}".to_sym
      end
    end
  end
end