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

      ##
      # Finds whether a map is locked. A map is unlocked only when a medal has
      # been achieved on the map before it.
      #
      # @param [Entities::Map] map
      def self.locked?(map)
        prev_map_idx = maps.map { |m| m.metadata.id }.index(map.metadata.id) - 1
        return false if prev_map_idx < 0
        prev_map = maps[prev_map_idx]

        SaveManager.load_map_state(prev_map)

        score = Gameplay::Scoring.overall_score_for_map(prev_map) || 0
        medal = map.metadata.medal_for(score)

        medal.nil?
      end 
    end
  end
end