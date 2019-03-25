require_relative 'controller'

module ScenicRoute
  module UI
    class TransitionController < Controller
      def initialize
        super

        @opacity = 0
        @covering = false
        @uncovering = false
      end

      def cover
        @covering = true
        @uncovering = false
      end

      def uncover
        @covering = false
        @uncovering = true
      end

      def draw
        if @covering && @opacity < 1
          @opacity += 0.05
        end
        if @uncovering && opacity > 0
          @opacity -= 0.05
        end

        Gosu.draw_rect(0, 0, Game::WIDTH, Game::HEIGHT,
          ((@opacity * 255).to_i << 24) + 0x000000, 999)
      end
    end
  end
end