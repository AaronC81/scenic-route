module ScenicRoute
  module Entities
    Point = Struct.new(:x, :y) do
      def heading_to(other)
        case [self.x <=> other.x, self.y <=> other.y]
        when [0, 1]
          :north
        when [0, -1]
          :south
        when [1, 0]
          :west
        when [-1, 0]
          :east
        else
          nil
        end
      end
    end
  end
end