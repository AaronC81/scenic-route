require 'gosu'
require_relative 'controller'
require_relative '../gameplay/scoring'
require_relative '../io/image_manager'
require_relative '../io/font_manager'
require_relative 'transition_controller'
require_relative '../io/level_manager'

module ScenicRoute
  module UI
    ##
    # Handles drawing a HUD on the screen.
    class HudController < Controller
      def initialize
        super

        @previous_valid_total_score = 0
        @previous_valid_scores = Hash.new(0)
        @next_level_button_showing = false
      end

      def reset
        @previous_valid_total_score = 0
        @previous_valid_scores = Hash.new(0)
        @next_level_button_showing = false
      end

      def draw
        return if map.nil?

        # Draw overall score
        scores = Gameplay::Scoring.scores_for_map(map)
        @previous_valid_total_score = scores.values.min if scores.values.all?

        IO::FontManager.font(30).draw_text('SCORE', 50, 18, 1, 1.0, 1.0,
          Gosu::Color::BLACK)
        IO::FontManager.font(70).draw_text(@previous_valid_total_score,
          50, 50, 1, 1.0, 1.0,
          scores.values.all? ? Gosu::Color::BLACK : Gosu::Color::GRAY)

        # Draw individual station scores
        scores.each.with_index do |(station, score), i|
          Gosu.draw_rect(i * 50 + 170, 70, 40, 40,
            Entities::StationObject::BACKGROUND_COLORS[station], 10)

          @previous_valid_scores[station] = score unless score.nil?

          IO::FontManager.font(25).draw_text_rel(@previous_valid_scores[station],
            i * 50 + 190, 90, 10, 0.5, 0.5,
            1, 1, !score.nil? \
              ? Entities::StationObject::TEXT_COLORS[station]
              : Entities::StationObject::INACTIVE_TEXT_COLORS[station])
        end

        # Draw a medal for the overall score
        medal = map.metadata.medal_for(@previous_valid_total_score) || 'none'
        medal_img = IO::ImageManager.image("medal_#{medal}".to_sym)

        medal_img.draw(170, 10, 10)

        # Draw the next level button, if necessary
        if medal != 'none'
          @next_level_button_showing = true
          next_level_img = IO::ImageManager.image(:button_next_level)
          next_level_img.draw(Game::WIDTH - next_level_img.width - 20, 20, 10)
          IO::FontManager.font(25).draw_text("Next\nLevel",
            Game::WIDTH - next_level_img.width + 10, 25, 10, 1, 1, 0xFF000000)
        else
          @next_level_button_showing = false
        end
      end

      def button_down(id)
        # TODO: not actually right coords but OK
        return unless id == Gosu::MS_LEFT && @next_level_button_showing &&
          mouse_point.x > 668 && mouse_point.y < 60 

        # TODO: make this reusable, as its copy-pasted from MenuCtrlr
        ControllerSupervisor.controller(TransitionController).cover_during do
          sleep 1
          
          # TODO: this is a very fragile way of getting the next level
          new_map_idx = IO::LevelManager.maps.map { |m| m.metadata.id}.index(map.metadata.id) + 1
          new_map = IO::LevelManager.maps[new_map_idx]
          ControllerSupervisor.load_map(new_map)
        end
      end
    end
  end
end