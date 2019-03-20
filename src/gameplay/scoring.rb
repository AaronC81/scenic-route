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
        # TODO: currently only supports one station pair
        # TODO: doesn't actually return nil on no station route
        stations = map.tile_objects.select { |x| x.is_a?(Entities::StationObject) }
        landmarks = map.tile_objects.select { |x| x.is_a?(Entities::LandmarkObject) }

        station_pairs = stations.group_by(&:number)

        score = 0

        station_pairs.each do |_, (a, b)|
          map.routes.each do |route|
            if route.connects?(a.point.moved(a.orientation), b.point.moved(b.orientation))
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

        score
      end
    end
  end
end