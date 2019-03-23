require 'gosu'
require_relative 'controller'
require_relative '../gameplay/scoring'
require_relative '../io/image_manager'

module ScenicRoute
  module UI
    ##
    # Handles drawing a HUD on the screen.
    class HudController < Controller
      LAPSUS_PRO = './res/font/LapsusPro-Bold.ttf'
      SILKSCREEN = './res/font/Silkscreen.ttf'

      attr_reader :map

      def initialize(map)
        super()

        @map = map
        @previous_valid_total_score = 0
        @previous_valid_scores = Hash.new(0)
      end

      def init_fonts
        @score_font ||= Gosu::Font.new(ControllerSupervisor.window, SILKSCREEN, 70)
        @heading_font ||= Gosu::Font.new(ControllerSupervisor.window, SILKSCREEN, 30)
        @mini_font ||= Gosu::Font.new(ControllerSupervisor.window, SILKSCREEN, 25)
      end

      def draw
        init_fonts

        # Draw overall score
        scores = Gameplay::Scoring.scores_for_map(map)
        @previous_valid_total_score = scores.values.min if scores.values.all?

        @heading_font.draw_text('SCORE', 50, 18, 1, 1.0, 1.0, Gosu::Color::BLACK)
        @score_font.draw_text(@previous_valid_total_score,
          50, 50, 1, 1.0, 1.0,
          scores.values.all? ? Gosu::Color::BLACK : Gosu::Color::GRAY)

        # Draw individual station scores
        scores.each.with_index do |(station, score), i|
          Gosu.draw_rect(i * 50 + 170, 70, 40, 40,
            Entities::StationObject::BACKGROUND_COLORS[station], 10)

          @previous_valid_scores[station] = score unless score.nil?

          @mini_font.draw_text_rel(@previous_valid_scores[station],
            i * 50 + 190, 90, 10, 0.5, 0.5,
            1, 1, !score.nil? \
              ? Entities::StationObject::TEXT_COLORS[station]
              : Entities::StationObject::INACTIVE_TEXT_COLORS[station])
        end

        # Draw a medal for the overall score
        medal = map.metadata.medal_for(@previous_valid_total_score) || 'none'
        medal_img = IO::ImageManager.image("medal_#{medal}".to_sym)

        medal_img.draw(170, 10, 10)
      end
    end
  end
end