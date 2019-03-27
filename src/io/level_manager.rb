require_relative 'map_loader'
require_relative '../tiles/tile_manager'

module ScenicRoute
  module IO
    ##
    # Handles loading levels from disc.
    class LevelManager
      ##
      # @return [Array<Map>] An array of each map from {level_paths} loaded
      #   with the world tile set.
      def self.maps
        level_paths.map do |path|
          MapLoader.load_map(path, Tiles::TileManager.tile_set(:world))
        end.sort_by { |m| m.metadata.sort_key }
      end

      ##
      # @return [Array<String>] The path to every known level file.
      def self.level_paths
        Dir['res/levels/*']
      end
    end
  end
end