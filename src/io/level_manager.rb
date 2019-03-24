require_relative 'map_loader'
require_relative '../tiles/tile_manager'

module ScenicRoute
  module IO
    class LevelManager
      def self.maps
        level_paths.map { |x| MapLoader.load_map(x, Tiles::TileManager.tile_set(:world)) }
      end

      def self.level_paths
        Dir['res/levels/*']
      end
    end
  end
end