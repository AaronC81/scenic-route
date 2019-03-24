require 'gosu'

module ScenicRoute
  module IO
    class ImageManager
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
        level_card: 'res/img/level_card.png'
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
