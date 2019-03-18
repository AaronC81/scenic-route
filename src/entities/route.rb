module ScenicRoute
  module Entities
    ##
    # Represents a route through some points on a {Map}.
    class Route
      ##
      # @return [Map] The map which this route is associated with.
      attr_reader :map
      
      ##
      # @return [Array<Point>] The points which make up this route, in order.
      attr_reader :points

      ##
      # Create a new route.
      #
      # @param [Map] map
      # @param [Array<Point>] points
      def initialize(map, points)
        @map = map
        @points = points
      end

      ##
      # Returns the tile name for the tile representing a particular direction
      # of movement onto and of off the tile. For example, moving onto a tile
      # north and leaving east would require an r-shaped bend.
      # 
      # Directions are specified as symbols, one of :north, :south, :east or
      # :west.
      #
      # @param [Symbol] in_heading The direction onto the tile.
      # @param [Symbol] out_heading The direction off of the tile.
      #
      # @return [Symbol] The tile name, which may be passed to {TileSet#tile}.
      #
      # @raise [ArgumentError] If there is no tile to represent the given
      #   movement.
      def tile_for_heading_delta(in_heading, out_heading)
        case [in_heading, out_heading]
        when [:north, :north], [:south, :south]
          :track_vertical_straight_on_ground
        when [:east, :east], [:west, :west]
          :track_horizontal_straight_on_ground
        when [:east, :south], [:north, :west]
          :track_south_west_bend
        when [:west, :north], [:south, :east]
          :track_north_east_bend
        when [:east, :north], [:south, :west]
          :track_north_west_bend
        when [:north, :east], [:west, :south]
          :track_south_east_bend
        else
          raise ArgumentError, 'impossible heading delta'
        end
      end

      ## 
      # Calculates the tiles which must be drawn over a map to display this
      # route as a track.
      #
      # @return [Hash] A hash of {Point} instances to tile name symbols. 
      #   When a map is being drawn, tile (x, y) should be replaced by the value
      #   for key (x, y) if it exists in this hash.
      def to_tile_hash
        return {} if points.length == 0
        return {points.first => :track_intersection} if points.length == 1

        # TODO: special cases, less than 3 points?
        result = {
          points.first => [:west, :east].include?(points.first.heading_to(points[1])) \
            ? :track_horizontal_straight_on_ground
            : :track_vertical_straight_on_ground,

          points.last => [:west, :east].include?(points.last.heading_to(points[-2])) \
            ? :track_horizontal_straight_on_ground
            : :track_vertical_straight_on_ground
        }

        points.each_cons(3) do |prev_pt, curr_pt, next_pt|
          direction_in = prev_pt.heading_to(curr_pt)
          direction_out = curr_pt.heading_to(next_pt)

          result[curr_pt] = tile_for_heading_delta(direction_in, direction_out)
        end

        result
      end

      ##
      # Joins this route with another and returns the new route. This ensures
      # that, if the two routes were going in different directions, the 
      # direction is normalised. The two routes should have no overlapping
      # points and have at least one adjacent end.
      #
      # @param [Route] other
      #
      # @return [Route] The joined route.
      def join(other)
        # TODO: length edge cases
        # TODO: check same map

        if points.first.adjacent_to?(other.points.first)
          combined = other.points.reverse + points
        elsif points.last.adjacent_to?(other.points.last)
          combined = points + other.points.reverse
        elsif points.first.adjacent_to?(other.points.last)
          combined = other.points + points
        elsif points.last.adjacent_to?(other.points.first)
          combined = points + other.points
        end

        Route.new(map, combined)
      end

      ##
      # Returns a boolean indicating whether an end of this route is adjacent
      # to an end of another one.
      #
      # @param [Route] other
      #
      # @return [Boolean]
      def adjacent_to?(other)
        points.first.adjacent_to?(other.points.first) \
          || points.last.adjacent_to?(other.points.last) \
          || points.first.adjacent_to?(other.points.last) \
          || points.last.adjacent_to?(other.points.first)
      end
    end
  end
end