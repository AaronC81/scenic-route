require_relative '../entities/station_object'

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
        stations = map.tile_objects.select { |x| x.is_a?(Entities::StationObject) }
        raise 'too many stations, unimplemented' unless stations.length == 2

        score = 0

        a, b = stations
        map.routes.each do |route|
          f, l = route.points.first, route.points.last
          # TODO: that conditional physically hurts
          if (a.point.heading_to(f) == a.orientation && b.point.heading_to(l) == b.orientation) \
            || (a.point.heading_to(l) == a.orientation && b.point.heading_to(f) == b.orientation)
            # This route links the two stations
            # Our score is its length

            score += route.points.length
          end
        end

        score
      end
    end
  end
end