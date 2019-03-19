require 'gosu'
require_relative 'controller'
require_relative '../gameplay/scoring'

module ScenicRoute
  module UI
    ##
    # Handles drawing a HUD on the screen.
    class HudController < Controller
      LAPSUS_PRO = './res/font/LapsusPro-Bold.ttf'

      attr_reader :map

      def initialize(map)
        super()

        @map = map
        @previous_valid_score = 0
      end

      def init_fonts
        @score_font ||= Gosu::Font.new(ControllerSupervisor.window, LAPSUS_PRO, 70)
        @label_font ||= Gosu::Font.new(ControllerSupervisor.window, LAPSUS_PRO, 30)
      end

      def draw
        init_fonts

        this_score = Gameplay::Scoring.score_for_map(map)
        this_score_valid = !this_score.nil? && this_score != 0
        @previous_valid_score = this_score if this_score_valid

        @label_font.draw_text('SCORE', 50, 18, 1, 1.0, 1.0, Gosu::Color::BLACK)
        @score_font.draw_text(@previous_valid_score,
          50, 50, 1, 1.0, 1.0,
          this_score_valid ? Gosu::Color::BLACK : Gosu::Color::GRAY)

        p @previous_valid_score
      end
    end
  end
end