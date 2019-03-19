module ScenicRoute
  module Entities
    ##
    # A geometric 2D point.
    Point = Struct.new('Point', :x, :y) do
      ##
      # Calculates the 4-directional compass heading to another point.
      #
      # @param [Point] other The other point.
      # @param [Boolean] require_adjacent If true, nil will be returned unless
      #   {other} is directly adjacent to this point.
      # 
      # @return [Symbol?] The compass heading from this point to another, either
      #   :north, :south, :east, or :west. If it is not directly along one of
      #   these headings, returns nil.
      def heading_to(other, require_adjacent=false)
        delta = require_adjacent \
          ? [self.x - other.x, self.y - other.y]
          : [self.x <=> other.x, self.y <=> other.y]

        if delta == [0, 1]
          :north
        elsif delta == [0, -1]
          :south
        elsif delta == [1, 0]
          :west
        elsif delta == [-1, 0]
          :east
        else
          nil
        end
      end

      ##
      # Returns a copy of this point moved one unit in a direction.
      #
      # @param [Symbol] direction The heading in which to move this point; one
      #   of :north, :south, :east or :west.
      #
      # @return [Point] A new, moved point.
      def moved(direction)
        case direction
        when :north
          Point.new(x, y - 1)
        when :south
          Point.new(x, y + 1)
        when :east
          Point.new(x + 1, y)
        when :west
          Point.new(x - 1, y)
        else
          raise ArgumentError, 'unknown direction'
        end
      end

      ##
      # Checks whether this point is adjacent to another point.
      #
      # @param [Point] other The other point.
      #
      # @return [Boolean] True if the points are adjacent, false otherwise.
      def adjacent_to?(other)
        heading_to(other, true) != nil
      end
    end
  end
end