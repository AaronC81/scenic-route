module ScenicRoute
  module Entities
    Point = Struct.new(:x, :y) do
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

      def adjacent_to?(other)
        heading_to(other, true) != nil
      end
    end
  end
end