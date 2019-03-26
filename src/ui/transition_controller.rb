require_relative 'controller'

module ScenicRoute
  module UI
    ##
    # Draws a transition animation when required.
    class TransitionController < Controller
      ##
      # @return [Proc] A function called once the current covering-up operation
      #   has finished drawing entirely. Don't assign to this unless it's 
      #   definitely a good idea; use {cover_during} instead.
      attr_accessor :covered_callback

      ##
      # Creates a new transition controller.
      def initialize
        super

        @opacity = 0
        @covering = false
        @uncovering = false
      end

      ##
      # Begins covering up the screen.
      def cover
        @covering = true
        @uncovering = false
      end

      ##
      # Begins uncovering the screen.
      def uncover
        @covering = false
        @uncovering = true
      end

      ##
      # Covers the screen, then runs a code block (in a background thread).
      # Once the given block completes, uncovers the screen.
      def cover_during(&block)
        cover
        self.covered_callback = ->{ Thread.new { block.(); uncover } }
      end

      ##
      # Draws the screen cover, if the screen is covered or being covered.
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