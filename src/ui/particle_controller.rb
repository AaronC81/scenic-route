module ScenicRoute
  module UI
    class ParticleController < Controller
      attr_reader :particles

      def initialize
        super()

        @particles = []
      end

      def spawn(particle)
        particles << particle
      end

      def draw
        super

        particles.delete_if do |particle|
          particle.image.draw_rot(
            particle.point.x, particle.point.y, 5, particle.rotation, 0.5, 0.5,
            1, 1, ((particle.opacity * 255).to_i << 24) + 0xFFFFFF
          )
          particle.tick
          particle.dead?
        end
      end
    end
  end
end