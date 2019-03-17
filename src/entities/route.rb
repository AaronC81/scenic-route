module ScenicRoute
  module Entities
    class Route
      attr_reader :map, :points

      def initialize(map, points)
        @map = map
        @points = points
      end

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

      def to_tile_map
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