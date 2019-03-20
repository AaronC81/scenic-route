require_relative '../entities/station_object'
require_relative '../entities/landmark_object'

module ScenicRoute
  module Gameplay
    ##
    # Contains methods allowing scores to be calculated for {Map} instances.
    class Scoring 
      ##
      # Calculates an overall score for a map.
      #
      # @param [Entities::Map] map The map to calculate a score for.
      # 
      # @return [Numeric?] The score, or nil if there is no station route.
      def self.score_for_map(map)
        stations = map.tile_objects.select { |x| x.is_a?(Entities::StationObject) }
        landmarks = map.tile_objects.select { |x| x.is_a?(Entities::LandmarkObject) }

        station_pairs = stations.group_by(&:number)

        score = 0
        connected_pairs = 0

        station_pairs.each do |_, (a, b)|
          map.routes.each do |route|
            if route.connects?(a.point.moved(a.orientation), b.point.moved(b.orientation))
              connected_pairs += 1
              route.points.each do |point|
                value = 1
                landmarks.each do |landmark|
                  value *= 2 if landmark.within_bonus_range?(point)
                end
                score += value
              end
            end
          end
        end

        connected_pairs == station_pairs.length ? score : nil
      end
    end
  end
end