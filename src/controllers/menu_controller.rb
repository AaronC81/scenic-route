require_relative 'controller'
require_relative 'controller_supervisor'
require_relative '../io/image_manager'
require_relative '../io/level_manager'
require_relative '../io/font_manager'
require_relative 'map_controller'
require_relative '../io/save_manager'
require_relative 'transition_controller'
require_relative 'hud_controller'
require_relative '../ui/mouse_element'
require_relative '../io/sample_manager'

module ScenicRoute
  module Controllers
    ##
    # Handles drawing the menu; that is, everything displayed when the map is
    # not being shown.
    class MenuController < Controller      
      ##
      # @return [Symbol] The current page of the menu. Either :title or
      #   :level_select.
      attr_accessor :current_page

      ##
      # @return [Entities::Map] The map which is currently being hovered over
      #   in the level selector.
      attr_accessor :hovered_map

      ##
      # Creates a new menu controller.
      def initialize
        super

        @button_bounds = {}
        @current_page = :title

        @mouse_click_anim = AnimationController.create_animation(
          [
            IO::ImageManager.image(:mouse),
            IO::ImageManager.image(:mouse_left_click)
          ], 45
        )

        level_card_img = IO::ImageManager.image(:level_card)
        @level_card_elements = IO::LevelManager.maps.map.with_index do |m, i|
          items_per_row = 6
          x = 100 + (i % items_per_row ? 100 * (i % items_per_row) : Game::WIDTH - level_card.width - 100)
          y = (i / items_per_row) * 100 + 150
          
          UI::MouseElement.new(Entities::Point.new(x, y), level_card_img,
            IO::ImageManager.image(:level_card_hover)).on_click do
            if !IO::LevelManager.locked?(m) && map.nil? && current_page == :level_select
              IO::SampleManager.sample(:select2).play
              ControllerSupervisor.controller(TransitionController).cover_during do
                sleep 1
                ControllerSupervisor.load_map(m)
              end
            end
          end.on_hover do
            next unless current_page == :level_select
            self.hovered_map = m
            IO::SaveManager.load_map_state(m)
            IO::SampleManager.sample(:hover).play
          end.on_unhover do
            next unless current_page == :level_select
            self.hovered_map = nil
          end
        end
      end

      ##
      # Draws the menu to the screen, if the map is not being shown.
      def draw
        return unless map.nil?

        case current_page
        when :level_select

          # Draw each level card
          @level_card_elements.each.with_index do |el, i|
            map = IO::LevelManager.maps[i]
            el.draw_element(50)
            IO::FontManager.font(30).draw_text_rel(
              IO::LevelManager.locked?(map) ? "?" : map.metadata.name,
              el.point.x + el.image.width / 2, el.point.y + el.image.height / 2,
              50, 0.5, 0.5, 1, 1, 0xFF000000
            )
          end

          # Draw the map preview
          unless hovered_map.nil?
            # Resize the map so it's 480 pixels wide
            target_width = 480.0
            map_scale_factor = target_width / hovered_map.pixel_width
            Gosu.scale(map_scale_factor) do
              hovered_map&.draw(800 / map_scale_factor, 70 / map_scale_factor, 50)
            end

            score = Gameplay::Scoring.overall_score_for_map(hovered_map) || 0
            IO::FontManager.font(30).draw_text("Score: #{score}", 810, 20, 50)

            medal = hovered_map.metadata.medal_for(score)
            medal_img = IO::ImageManager.image("medal_#{medal || 'none'}".to_sym)

            medal_img.draw(Game::WIDTH - medal_img.width - 10, 10, 50)
          end

        when :title
          logo = IO::ImageManager.image(:logo)

          Gosu.draw_rect(0, 0, Game::WIDTH, Game::HEIGHT, 0xFFFFFFFF, 50)
          logo.draw((Game::WIDTH - logo.width) / 2, (Game::HEIGHT - logo.height) / 2, 50)

          mouse = IO::ImageManager.image(:mouse) # only used for width/height reference
          @mouse_click_anim.draw((Game::WIDTH - mouse.width) / 2, Game::HEIGHT / 2 + 200, 50)
        end
      end

      ##
      # Handles menu button clicks.
      def button_down(id)
        super
        return if id != Gosu::MS_LEFT

        if current_page == :title
          ControllerSupervisor.controller(TransitionController).cover_during do
            sleep 1
            self.current_page = :level_select
          end
        end
      end
    end
  end
end