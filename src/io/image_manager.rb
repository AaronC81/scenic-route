require 'gosu'

module ScenicRoute
  module IO
    class ImageManager
      IMAGE_PATHS = {
        particle_sparkle: 'res/img/sparkle.png'
      }

      def self.image(name)
        image_path = IMAGE_PATHS[name]
        raise 'no such image' if image_path.nil?

        # TODO: memoise images

        Gosu::Image.new(image_path)
      end
    end
  end
end
