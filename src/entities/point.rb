module ScenicRoute
  module Entities
    Point = Struct.new(:x, :y) do
      def heading_to(other, require_adjacent=false)
        delta = require_adjacent \
          ? [self.x - other.x, self.y - other.y]
          : [self.x <=> other.x, self.y <=> other.y]

        {
          [0, 1] => :north,
          [0, -1] => :south,
          [1, 0] => :west,
          [-1, 0] => :east
        }[delta]
      end

      def adjacent_to?(other)
        heading_to(other, true) != nil
      end
    end
  end
end