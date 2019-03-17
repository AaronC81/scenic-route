module ScenicRoute
  module Entities
    Point = Struct.new(:x, :y) do
      def heading_to(other, require_adjacent=false)
        delta = require_adjacent \
          ? [self.x - other.x, self.y - other.y]
          : [self.x <=> other.x, self.y <=> other.y]

        p delta

        {
          [0, 1] => :north,
          [0, -1] => :south,
          [1, 0] => :west,
          [-1, 0] => :east
        }[delta]
      end
    end
  end
end