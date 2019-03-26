require_relative 'controller'
require_relative 'controller_supervisor'
require_relative '../io/image_manager'
require_relative '../io/level_manager'
require_relative '../io/font_manager'
require_relative 'map_controller'
require_relative '../io/save_manager'
require_relative 'transition_controller'
require_relative 'hud_controller'

module ScenicRoute
  module UI
    class MenuController < Controller
      attr_accessor :on_menu
      alias on_menu? on_menu

      attr_accessor :current_page

      def initialize
        super

        @button_bounds = {}
        @on_menu = true
        @current_page = :title

        @mouse_click_anim = AnimationController.create_animation(
          [
            IO::ImageManager.image(:mouse),
            IO::ImageManager.image(:mouse_left_click)
          ], 45
        )
      end

      def draw
        return unless map.nil?

        case current_page
        when :level_select
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
        when :title
          logo = IO::ImageManager.image(:logo)

          Gosu.draw_rect(0, 0, Game::WIDTH, Game::HEIGHT, 0xFFFFFFFF, 50)
          logo.draw((Game::WIDTH - logo.width) / 2, (Game::HEIGHT - logo.height) / 2, 50)

          mouse = IO::ImageManager.image(:mouse) # only used for width/height reference
          @mouse_click_anim.draw((Game::WIDTH - mouse.width) / 2, Game::HEIGHT / 2 + 200, 50)
        end
      end

      def button_down(id)
        super
        return if id != Gosu::MS_LEFT || !on_menu?

        case current_page
        when :level_select
          @button_bounds.each do |map, bound|
            x, y, width, height = bound
            if mouse_point.x >= x && mouse_point.y >= y \
              && mouse_point.x <= x + width && mouse_point.y <= y + height
              self.on_menu = false

              # TODO: make this reusable, as its copy-pasted into HUD's next level
              ControllerSupervisor.controller(TransitionController).cover_during do
                sleep 1
                ControllerSupervisor.controller(MapController).load(map)
                IO::SaveManager.load_map_state(map)
                ControllerSupervisor.controller(HudController).reset
              end
            end
          end
        when :title
          ControllerSupervisor.controller(TransitionController).cover_during do
            sleep 1
            self.current_page = :level_select
          end
        end
      end
    end
  end
end