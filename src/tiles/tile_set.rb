module ScenicRoute
  module Tiles
    ## 
    # An ordered collection of images, possibly with names attached to certain
    # indeces.
    class TileSet
      ##
      # @return [Array<Gosu::Image>] The images in this tile set.
      attr_reader :images
      
      ##
      # @return [Hash] A hash of names as symbols to indeces in {#images}.
      :tile_definitions

      ##
      # Create a new tile set.
      # 
      # @param [Array<Gosu::Image>] images
      # @param [Hash] tile_definitions
      def initialize(images, tile_definitions=nil)
        @images = images
        @tile_definitions = tile_definitions
      end

      ##
      # Retrieve a tile image from the tile set by name.
      #
      # @param [Symbol] name The name of the tile, which must be a key in
      #   {#tile_definitions}.
      # 
      # @return [Gosu::Image]
      #
      # @raise [RuntimeError] if {#tile_definitions} is nil.
      # @raise [ArgumentError] if there is no tile with the given name.
      def tile(name)
        raise 'no tile definitions' if tile_definitions.nil?
        raise ArgumentError, "no tile #{name}" if tile_definitions[name].nil?
        images[tile_definitions[name]]
      end

      def inspect
        puts "#<TileSet: #{images.length} images, #{tile_definitions&.length} defs>"
      end
    end
  end
end