require 'gosu'

module ScenicRoute
  module IO
    ##
    # Handles loading images from files through symbolic image names.
    class ImageManager
      ##
      # A map of image symbols to their filepaths.
      IMAGE_PATHS = {
        particle_sparkle: 'res/img/particles/sparkle.png',
        medal_gold: 'res/img/medals/gold.png',
        medal_silver: 'res/img/medals/silver.png',
        medal_bronze: 'res/img/medals/bronze.png',
        medal_none: 'res/img/medals/none.png',
        dialogue_conductor: 'res/img/conductor.png',
        mouse_left_click: 'res/img/mouse_left_click.png',
        mouse: 'res/img/mouse.png',
        dialogue_background: 'res/img/dialogue_background.png',
        level_card: 'res/img/level_card.png',
        button_next_level: 'res/img/button_next_level.png',
        logo: 'res/img/logo.png'
      }

      ##
      # Loads an image from a file given its symbolic name, which must be a key
      # in {IMAGE_PATHS}.
      #
      # @param [Symbol] name
      # @return [Gosu::Image]
      def self.image(name)
        image_path = IMAGE_PATHS[name]
        raise 'no such image' if image_path.nil?

        # TODO: memoise images

        Gosu::Image.new(image_path)
      end
    end
  end
end
