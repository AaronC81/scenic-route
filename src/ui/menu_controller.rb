require_relative 'controller'
require_relative 'controller_supervisor'
require_relative '../io/image_manager'
require_relative '../io/level_manager'

module ScenicRoute
  module UI
    class MenuController < Controller
      def draw
        level_card = IO::ImageManager.image(:level_card)

        IO::LevelManager.maps.each.with_index do |m, i|
          x = i.even? ? 100 : Game::WIDTH - level_card.width - 100
          y = (i / 2.to_i) * 100 + 150
          level_card.draw(x, y, 20)

          Gosu::Font.new(ControllerSupervisor.window, 'res/font/Silkscreen.ttf', 30).draw_text(
            m.metadata.name, x + 15, y + 15, 20, 1, 1, 0xFF000000
          )
        end
      end
    end
  end
end