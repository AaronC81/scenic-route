require_relative 'controller'

module ScenicRoute
  module UI
    class AnimationController < Controller
      Animation = Struct.new('Animation', :frames, :frame_ticks, :index, :timer) do
        def draw(*args)
          AnimationController.draw_animation(self, *args)
        end
      end

      def self.create_animation(frames, frame_ticks)
        Animation.new(frames, frame_ticks, 0, 0)
      end

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