require 'gosu'
require_relative 'tile_set'
require_relative 'world_tile_set'

module ScenicRoute
  module Tiles
    ##
    # A static class which handles loading of tile sets.
    class TileManager
      ##
      # A mapping of known tile set names to their filepaths and tile sizes.
      # TODO: want buffers on new station graphic track
      # TODO: make everything look less obviously looping, maybe randomly
      # generate/rotate textures or something idk
      TILE_SET_NAMES = {
        world: [WorldTileSet, 'res/img/world.png', 64, 64]
      }

      ##
      # A mapping of known tile set names to their tile definition hashes.
      TILE_SET_DEFINITIONS = {
        world: {
          # The bend directions specify the sides on which the bend is open
          track_south_east_bend: 0,
          track_north_west_bend: 2,
          track_north_east_bend: 3,
          track_south_west_bend: 1,
          track_intersection: 4,
          track_vertical_straight_on_ground: 5,
          track_horizontal_straight_on_ground: 6,
          scene_ground: 7,
          scene_backdrop: 8,
          object_station_south: 9,
          object_station_north: 10,
          object_station_east: 11,
          object_station_west: 12,
          placeholder: 13,
          object_landmark_statue: 14
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
          kind, filename, width, height = TILE_SET_NAMES[name]
        elsif name.is_a?(String)
          filename = name
          kind = TileSet
        else
          raise ArgumentError, 'tile set name must be a string or symbol'
        end
        
        raise ArgumentError, 'no dimensions given' if width.nil? || height.nil?
        result = Gosu::Image.load_tiles(filename, width, height)
          
        # Use supplied tile defs for this tileset, or look at the ones we know
        defs = tile_definitions || TILE_SET_DEFINITIONS[name]

        # Memoise and return this tileset
        @@loaded_tile_sets[name] = kind.new(result, width, height, defs)
      end
    end
  end
end