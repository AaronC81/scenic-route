module ScenicRoute
  module Tiles
    class TileSet
      attr_reader :images, :tile_definitions

      def initialize(images, tile_definitions=nil)
        @images = images
        @tile_definitions = tile_definitions
      end

      def tile(name)
        raise 'no tile definitions' if tile_definitions.nil?
        images[tile_definitions[name]]
      end

      def inspect
        puts "#<TileSet: #{images.length} images, #{tile_definitions&.length} defs>"
      end
    end
  end
end