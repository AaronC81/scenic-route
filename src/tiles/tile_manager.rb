require 'gosu'
require_relative 'tile_set'

module ScenicRoute
  module Tiles
    ##
    # A static class which handles loading of tile sets.
    class TileManager
      ##
      # A mapping of known tile set names to their filepaths and tile sizes.
      TILE_SET_NAMES = {
        track: ['res/roads.png', 64, 64]
      }

      ##
      # A mapping of known tile set names to their tile definition hashes.
      TILE_SET_DEFINITIONS = {
        track: {
          # The bend directions specify the sides on which the bend is open
          south_east_bend: 0,
          north_west_bend: 7,
          north_east_bend: 15,
          south_west_bend: 20,
          intersection: 23,
          vertical_straight_on_grass: 6,
          horizontal_straight_on_grass: 31,
          grass: 33,
          water: 36
        }
      }

      ##
      # Loads a tile set from a file. Once loaded, the tile set is memoised
      # to reduce disk usage.
      #
      # @param [Symbol, String] name The name of the tile set, either as a
      #   symbol key from {TILE_SET_NAMES} or as a string filepath. Note that,
      #   if using a symbol, all future parameters' values are ignored.
      # @param [Numeric] width The width of each tile.
      # @param [Numeric] height The height of each tile.
      # @param [Hash] tile_definitions The tile definitions for the resulting
      #   tile set to use.
      #
      # @return [TileSet] The loaded tile set.
      def self.tile_set(name, width=nil, height=nil, tile_definitions=nil)
        @@loaded_tile_sets ||= {}

        # See if we have a memoised copy of this tile set
        return @@loaded_tile_sets[name] unless @@loaded_tile_sets[name].nil?

        # Load this tile set according to what its name was specified as
        if name.is_a?(Symbol)
          raise ArgumentError, 'unknown tile set' if TILE_SET_NAMES[name].nil?
          filename, width, height = TILE_SET_NAMES[name]
        elsif name.is_a?(String)
          filename = name
        else
          raise ArgumentError, 'tile set name must be a string or symbol'
        end
        
        raise ArgumentError, 'no dimensions given' if width.nil? || height.nil?
        result = Gosu::Image.load_tiles(filename, width, height)
          
        # Use supplied tile defs for this tileset, or look at the ones we know
        defs = tile_definitions || TILE_SET_DEFINITIONS[name]

        # Memoise and return this tileset
        @@loaded_tile_sets[name] = TileSet.new(result, width, height, defs)
      end
    end
  end
end