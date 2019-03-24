require_relative 'controller'
require_relative 'controller_supervisor'
require_relative '../io/image_manager'
require_relative '../io/level_manager'
require_relative '../io/font_manager'
require_relative 'map_controller'

module ScenicRoute
  module UI
    class MenuController < Controller
      attr_accessor :on_menu
      alias on_menu? on_menu

      def initialize
        super

        @button_bounds = {}
        @on_menu = true
      end

      def draw
        return unless map.nil?
        level_card = IO::ImageManager.image(:level_card)

        IO::LevelManager.maps.each.with_index do |m, i|
          x = i.even? ? 100 : Game::WIDTH - level_card.width - 100
          y = (i / 2.to_i) * 100 + 150
          level_card.draw(x, y, 50)

          @button_bounds[m] ||= [x, y, level_card.width, level_card.height]

          IO::FontManager.font(30).draw_text(
            m.metadata.name, x + 15, y + 15, 50, 1, 1, 0xFF000000
          )
        end
      end

      def button_down(id)
        super
        return if id != Gosu::MS_LEFT || !on_menu?

        @button_bounds.each do |map, bound|
          x, y, width, height = bound
          if mouse_point.x >= x && mouse_point.y >= y \
            && mouse_point.x <= x + width && mouse_point.y <= y + height
            self.on_menu = false
            ControllerSupervisor.controller(MapController).load(map)
          end
        end
      end
    end
  end
end