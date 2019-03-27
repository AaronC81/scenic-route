require_relative '../entities/station_object'
require_relative '../entities/landmark_object'
require_relative '../entities/route'

module ScenicRoute
  module Gameplay
    ##
    # Contains methods allowing scores to be calculated for {Entities::Map}
    # instances.
    class Scoring 
      ##
      # Calculates an overall score for a map.
      #
      # @param [Entities::Map] map The map to calculate a score for.
      # 
      # @return [Hash<Numeric?>] The scores for each pair, or nil if there is
      # no station route.
      def self.scores_for_map(map)
        stations = map.tile_objects(Entities::StationObject)

        station_pairs = stations.group_by(&:number)

        station_pairs.map do |num, (a, b)|
          scores = map.routes.map do |route|
            route.connects?(a.point.moved(a.orientation),
              b.point.moved(b.orientation)) ? score_for_route(route) : nil
          end.compact

          [num, scores.one? ? scores.first : nil]
        end.to_h
      end

      ##
      # Calculates a single overall score for a map.
      #
      # @param [Entities::Map] map
      # @return [Integer]
      def self.overall_score_for_map(map)
        scores_for_map(map).values.min
      end

      ## 
      # Calculates a score for a single route. It is the caller's responsibility
      # to ensure that the route is complete.
      #
      # @param [Entities::Route] route The route.
      #
      # @return [Numeric?] The score for this route, or nil if the route is
      #   incomplete.
      def self.score_for_route(route)
        landmarks = route.map.tile_objects(Entities::LandmarkObject)

        score = 0
        route.points.each do |point|
          value = 1
          landmarks.each do |landmark|
            value *= 2 if landmark.within_bonus_range?(point)
          end
          score += value
        end
        score
      end
    end
  end
end