module ScenicRoute
  module Entities
    class Particle
      attr_accessor :point, :speed_x, :speed_y, :rotation, :angular_velocity,
        :lifetime, :opacity, :opacity_delta, :ticks, :lifetime_ticks, :image

      def t(value)
        value / 60
      end

      def initialize(origin, image, speed_x, speed_y, rotation, 
        angular_velocity, lifetime, opacity)
        @image = image
        @point = origin

        def evaluate_param(x); (x.is_a?(Range) ? rand(x) : x).to_f; end

        @speed_x = evaluate_param(speed_x)
        @speed_y = evaluate_param(speed_y)
        @rotation = evaluate_param(rotation)
        @angular_velocity = evaluate_param(angular_velocity)
        @lifetime = evaluate_param(lifetime)
        @opacity = evaluate_param(opacity)
        @opacity_delta = -@opacity / lifetime

        @ticks = 0
        @lifetime_ticks = 60 * lifetime
      end

      def tick
        return if dead?
        @ticks += 1
        point.x += t(speed_x)
        point.y += t(speed_y)
        @rotation += t(angular_velocity)
        @opacity += t(opacity_delta)
      end

      def dead?
        ticks >= lifetime_ticks
      end
    end
  end
end