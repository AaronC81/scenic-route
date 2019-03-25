require_relative 'controller'

module ScenicRoute
  module UI
    class TransitionController < Controller
      attr_accessor :covered_callback

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
        must_call_covered_callback = false
        if @covering && @opacity < 1
          @opacity += 0.05
          if @opacity >= 1
            @opacity = 1 # fix float error
            must_call_covered_callback = true
          end
        end
        if @uncovering && @opacity > 0
          @opacity -= 0.05
          if @opacity <= 0
            @opacity = 0 # fix float error
          end
        end

        Gosu.draw_rect(0, 0, Game::WIDTH, Game::HEIGHT,
          ((@opacity * 255).to_i << 24) + 0x000000, 999)

        if must_call_covered_callback
          covered_callback&.() 
          covered_callback = nil
        end
      end
    end
  end
end