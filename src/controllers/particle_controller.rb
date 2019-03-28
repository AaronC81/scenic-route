require_relative 'controller'

module ScenicRoute
  module Controllers
    ##
    # Handles drawing {Entities::Particle} instances to the screen.
    class ParticleController < Controller
      ##
      # @return [Array<Entities::Particle>] The particles currently being drawn.
      attr_reader :particles

      ##
      # Creates a new particle controller.
      def initialize
        super

        @particles = []
      end

      ##
      # Spawns a new particle, adding it to this controller.
      def spawn(particle)
        particles << particle
      end

      ##
      # Draws each particle known to this controller and ticks its attributes.
      # If a particle dies, it is removed from {particles}. 
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