require_relative 'controller'

module ScenicRoute
  module UI
    ##
    # Enables the creation of animations, which rotate between images after a 
    # certain number of ticks.
    class AnimationController < Controller
      ##
      # Represents an animation.
      Animation = Struct.new('Animation', :frames, :frame_ticks, :index, :timer) do
        # @!attribute frames
        #   @return [Array<Gosu::Image>] The frames of this animation.

        # @!attribute frame_ticks
        #   @return [Integer] How many ticks to remain on one frame.

        # @!attribute index
        #   @return [Integer] The current frame as an index of {frames}.

        # @!attribute timer
        #   @return [Integer] The number of ticks elapsed since the last frame
        #     change.

        ##
        # Requests that the {AnimationController} draws the current frame of
        # this animation.
        def draw(*args)
          AnimationController.draw_animation(self, *args)
        end
      end

      ##
      # Creates a new {Animation} instance with {Animation#index} and 
      # {Animation#timer} initialised to 0.
      #
      # @param [Array<Gosu::Image>] frames
      # @param [Integer] frame_ticks
      # @return [Animation]
      def self.create_animation(frames, frame_ticks)
        Animation.new(frames, frame_ticks, 0, 0)
      end

      ##
      # Draws the current frame of an {Animation} to the screen and progresses
      # it by a single tick. This argument takes varargs which are passed to
      # the Gosu image's +draw+ method.
      #
      # @param [Animation] animation
      def self.draw_animation(animation, *args)
        animation.frames[animation.index].draw(*args)

        animation.timer += 1
        if animation.timer == animation.frame_ticks 
          animation.timer = 0
          animation.index = (animation.index + 1) % animation.frames.length
        end
      end
    end
  end
end