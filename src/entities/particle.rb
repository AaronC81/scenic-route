module ScenicRoute
  module Entities
    ##
    # Particles are images which have their properties changed dynamically each
    # tick by a {UI::ParticleController}. A particle's opacity fades over its
    # lifetime.
    class Particle
      attr_accessor :point, :speed_x, :speed_y, :rotation, :angular_velocity,
        :lifetime, :opacity, :opacity_delta, :ticks, :lifetime_ticks, :image

      ##
      # A convenience method which converts a time value in ticks into a time
      # value in seconds.
      # @param [Numeric] value A time value in ticks.
      # @return [Numeric] A time value in seconds.
      def t(value)
        value / Game::FPS
      end

      ##
      # Creates a new particle.
      # With the exception of origin and image, all parameters may either be
      # {Numeric} or {Range}. If they are {Numeric}, they are left intact; if
      # they are {Range}, a random value is chosen for them using {rand}.
      # Note that this random value is chosen in the constructor, not every
      # tick.
      # @param [Point] origin
      # @param [Image] image
      def initialize(origin, image, speed_x, speed_y, rotation, 
        angular_velocity, lifetime, opacity)
        @image = image
        @point = origin

        ##
        # Given a {Range}, returns a value from it. Otherwise, returns the
        # input {Numeric}.
        # @param [Range, Numeric] x
        # @return [Float]
        def evaluate_param(x); (x.is_a?(Range) ? rand(x) : x).to_f; end

        @speed_x = evaluate_param(speed_x)
        @speed_y = evaluate_param(speed_y)
        @rotation = evaluate_param(rotation)
        @angular_velocity = evaluate_param(angular_velocity)
        @lifetime = evaluate_param(lifetime)
        @opacity = evaluate_param(opacity)
        @opacity_delta = -@opacity / lifetime

        @ticks = 0
        @lifetime_ticks = Game::FPS * lifetime
      end

      ##
      # Increments all necessary parameters of this particle, unless the
      # particle is dead.
      def tick
        return if dead?
        @ticks += 1
        point.x += t(speed_x)
        point.y += t(speed_y)
        @rotation += t(angular_velocity)
        @opacity += t(opacity_delta)
      end

      ##
      # @return [Boolean] Whether or not this particle has met or exceeded its
      #   lifetime.
      def dead?
        ticks >= lifetime_ticks
      end
    end
  end
end