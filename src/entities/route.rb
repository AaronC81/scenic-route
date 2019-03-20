require_relative '../ui/controller_supervisor'
require_relative '../ui/particle_controller'

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
        
        # Handle the special case that the end of this route is next to an 
        # object which can connect to a track.
        # This is merely a cosmetic alteration.
        map.tile_objects.each do |object|
          if object.track_connectivity[object.point.heading_to(points.first, true)]
            result[points.first] = tile_for_heading_delta(
              object.point.heading_to(points.first, true),
              points.first.heading_to(points[1])
            )
          end

          if object.track_connectivity[object.point.heading_to(points.last, true)]
            result[points.last] = tile_for_heading_delta(
              object.point.heading_to(points.last, true),
              points.last.heading_to(points[-2])
            )
          end
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

      ##
      # Returns a boolean indicating whether this route has ends at exactly
      # the two given points.
      #
      # @param [Point] a
      # @param [Point] b
      #
      # @return [Boolean]
      def connects?(a, b)
        (points.first == a && points.last == b) \
          || (points.last == a && points.first == b)
      end

      ##
      # Returns a boolean indicating if this route is a complete route between a
      # pair of matching stations.
      #
      # @return [Boolean]
      def complete?
        stations = map.tile_objects.select { |x| x.is_a?(Entities::StationObject) }
        station_pairs = stations.group_by(&:number)

        station_pairs.each do |_, (a, b)|
          if connects?(a.point.moved(a.orientation), b.point.moved(b.orientation))
            return true
          end
        end

        false
      end

      def sparkle
        img = Gosu::Image.new('res/img/sparkle.png')

        points.each do |point|
          x = map.controller.origin.x + point.x * map.tile_set.width + rand(map.tile_set.width)
          y = map.controller.origin.y + point.y * map.tile_set.height + rand(map.tile_set.height)

          3.times do
            UI::ControllerSupervisor.controller(UI::ParticleController).spawn(
              Entities::Particle.new(
                Entities::Point.new(x, y), img, -50..50, -50..50, 0, 0, 0.5, 1
              )
            )
          end
        end
      end
    end
  end
end