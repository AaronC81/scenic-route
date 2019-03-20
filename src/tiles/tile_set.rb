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
      attr_reader :tile_definitions

      ##
      # @return [Numeric] The width of one tile.
      attr_reader :width

      ##
      # @return [Numeric] The height of one tile.
      attr_reader :height

      ##
      # Create a new tile set.
      # 
      # @param [Array<Gosu::Image>] images
      # @param [Numeric] width
      # @param [Numeric] height
      # @param [Hash] tile_definitions
      def initialize(images, width=nil, height=nil, tile_definitions=nil)
        @images = images
        @width = width
        @height = height
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
        "#<TileSet: #{images.length} images, #{tile_definitions&.length} defs>"
      end
    end
  end
end