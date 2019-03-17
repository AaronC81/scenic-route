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
          :vertical_straight_on_grass
        when [:east, :east], [:west, :west]
          :horizontal_straight_on_grass
        when [:east, :south], [:north, :west]
          :south_west_bend
        when [:west, :north], [:south, :east]
          :north_east_bend
        when [:east, :north], [:south, :west]
          :north_west_bend
        when [:north, :east], [:west, :south]
          :south_east_bend
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
        # TODO: special cases, less than 3 points?
        result = {
          points.first => :horizontal_straight_on_grass, # TODO
          points.last => :horizontal_straight_on_grass  # TODO
        }

        points.each_cons(3) do |prev_pt, curr_pt, next_pt|
          direction_in = prev_pt.heading_to(curr_pt)
          direction_out = curr_pt.heading_to(next_pt)

          puts "#{direction_in} -> #{direction_out}"

          result[curr_pt] = tile_for_heading_delta(direction_in, direction_out)
        end

        result
      end
    end
  end
end