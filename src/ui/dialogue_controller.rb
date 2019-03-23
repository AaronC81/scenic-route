require_relative 'controller'
require_relative '../io/image_manager'

module ScenicRoute
  module UI
    class DialogueController < Controller
      # TODO: disable controls during dialogue using a boolean accessor in 
      # MapController

      CHARACTER_TIME = 3

      attr_accessor :dialogue_queue

      attr_accessor :current_index

      def initialize
        super
        @dialogue_queue = []
        @current_index = 0
        @current_index_tick_counter = 0
        @character_bob_tick_counter = 0
        @character_bob = false
        @mouse_click_animation_tick_counter = 0
        @mouse_click_animation = false
      end

      def draw
        return if dialogue_queue.empty?

        ControllerSupervisor.controller(MapController).controls_enabled = false

        # Dim background
        Gosu.draw_rect(0, 0, Game::WIDTH, Game::HEIGHT, 0xBB000000, 20)
        
        # Draw the conductor
        conductor_image = IO::ImageManager.image(:dialogue_conductor)
        conductor_image.draw(Game::WIDTH - conductor_image.width - 30,
          Game::HEIGHT - conductor_image.height + (@character_bob ? 7 : 0), 20) 

        # Draw the text background
        background_image = IO::ImageManager.image(:dialogue_background)
        background_image.draw(Game::WIDTH / 2 - 300, Game::HEIGHT - 180, 20)

        # Draw the text
        Gosu::Font.new(ControllerSupervisor.window, 'res/font/Silkscreen.ttf', 30).draw_text(
          dialogue_queue.first[0..@current_index],
          Game::WIDTH / 2 - 280, Game::HEIGHT - 160, 20, 1, 1, 0xFF000000
        )

        # If necessary, draw the click indicator
        if current_done?
          mouse_image = IO::ImageManager.image(
            @mouse_click_animation ? :mouse_left_click : :mouse
          )
          mouse_image.draw(Game::WIDTH / 2 + 300, Game::HEIGHT - 160, 20)
        end
      end

      def update
        return if dialogue_queue.empty?
        
        @current_index_tick_counter += 1
        if @current_index_tick_counter % CHARACTER_TIME == 0 && !current_done?
          @current_index_tick_counter = 0
          @current_index += 1 
        end

        @character_bob_tick_counter += 1
        if @character_bob_tick_counter % (CHARACTER_TIME * 3) == 0 && !current_done?
          @character_bob_tick_counter = 0
          @character_bob = !@character_bob 
        end

        @mouse_click_animation_tick_counter += 1
        if @mouse_click_animation_tick_counter % (CHARACTER_TIME * 6) == 0
          @mouse_click_animation_tick_counter = 0
          @mouse_click_animation = !@mouse_click_animation 
        end
      end

      def advance
        @dialogue_queue.shift
        @current_index = 0
        @current_index_tick_counter = 0
        @character_bob_tick_counter = 0
        @character_bob = false

        ControllerSupervisor.controller(MapController).controls_enabled = true \
          if @dialogue_queue.empty?
      end

      def current_done?
        @current_index == dialogue_queue.first.length - 1
      end

      def button_down(id)
        return if dialogue_queue.empty? || id != Gosu::MS_LEFT

        if current_done?
          advance
        else
          @current_index = dialogue_queue.first.length - 1
        end
      end
    end
  end
end