require 'gosu'
require_relative 'tile_set'

module ScenicRoute
  module Tiles
    class TileManager
      TILE_SET_NAMES = {
        track: ['res/roads.png', 64, 64]
      }

      TILE_SET_DEFINITIONS = {
        track: {
          south_east_bend: 0,
          north_west_bend: 7,
          north_east_bend: 16,
          south_west_bend: 21,
          vertical_straight_on_grass: 6,
          horizontal_straight_on_grass: 31,
          grass: 33,
          water: 36
        }
      }

      # Loads a tile set from a file.
      def self.tile_set(name, width=nil, height=nil, tile_definitions=nil)
        @@loaded_tile_sets ||= {}

        # See if we have a memoised copy of this tile set
        return @@loaded_tile_sets[name] unless @@loaded_tile_sets[name].nil?

        # Load this tile set according to what its name was specified as
        if name.is_a?(Symbol)
          raise ArgumentError, 'unknown tile set' if TILE_SET_NAMES[name].nil?
          result = Gosu::Image.load_tiles(*TILE_SET_NAMES[name])
        elsif name.is_a?(String)
          raise ArgumentError, 'no dimensions given' if width.nil? || height.nil?
          result = Gosu::Image.load_tiles(name, width, height)
        else
          raise ArgumentError, 'tile set name must be a string or symbol'
        end

        # Use supplied tile defs for this tileset, or look at the ones we know
        defs = tile_definitions || TILE_SET_DEFINITIONS[name]

        # Memoise and return this tileset
        @@loaded_tile_sets[name] = TileSet.new(result, defs)
      end
    end
  end
end