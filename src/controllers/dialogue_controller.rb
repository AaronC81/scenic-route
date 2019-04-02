require_relative 'controller'
require_relative '../io/image_manager'
require_relative '../io/font_manager'
require_relative '../io/sample_manager'
require_relative 'animation_controller'

module ScenicRoute
  module Controllers
    ##
    # Draws dialogue for the currently loaded map.
    class DialogueController < Controller
      ##
      # The ticks between each character being printed during ongoing dialogue.
      # Some other factors, such as The Conductor's bobbing, are relative to
      # this.
      CHARACTER_TIME = 3

      ##
      # @return [Array<String>] The queue of messages waiting to be printed.
      attr_accessor :dialogue_queue

      ##
      # @return [Integer] The character in the current dialogue message which
      #   has been reached by the printing animation so far.
      attr_accessor :current_index

      ##
      # Creates a new dialogue controller.
      def initialize
        super
        @dialogue_queue = []
        @current_index = 0
        @current_index_tick_counter = 0
        @character_bob_tick_counter = 0
        @character_bob = false

        @mouse_click_anim = AnimationController.create_animation(
          [
            IO::ImageManager.image(:mouse),
            IO::ImageManager.image(:mouse_left_click)
          ], 15
        )
      end

      ##
      # Draws dialogue, The Conductor, and anything else required to the screen,
      # if dialogue is ongoing. Also disables map controls.
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
        IO::FontManager.font(30).draw_text(
          dialogue_queue.first[0..@current_index],
          Game::WIDTH / 2 - 280, Game::HEIGHT - 160, 20, 1, 1, 0xFF000000
        )

        # If necessary, draw the click indicator
        if current_done?
          @mouse_click_anim.draw(Game::WIDTH / 2 + 300, Game::HEIGHT - 160, 20)
        end
      end

      ##
      # Updates animation counters if dialogue is ongoing.
      def update
        return if dialogue_queue.empty?
        
        @current_index_tick_counter += 1
        if @current_index_tick_counter % CHARACTER_TIME == 0 && !current_done?
          @current_index_tick_counter = 0
          @current_index += 1 
          IO::SampleManager.sample(:speak).play unless
            dialogue_queue.first[@current_index] == ' '
        end

        @character_bob_tick_counter += 1
        if @character_bob_tick_counter % (CHARACTER_TIME * 3) == 0 && !current_done?
          @character_bob_tick_counter = 0
          @character_bob = !@character_bob 
        end
      end

      ##
      # Moves onto the next dialogue message and resets any animation counters.
      # If the last message was just advanced from, re-enables map controls.
      def advance
        @dialogue_queue.shift
        @current_index = 0
        @current_index_tick_counter = 0
        @character_bob_tick_counter = 0
        @character_bob = false

        ControllerSupervisor.controller(MapController).controls_enabled = true \
          if @dialogue_queue.empty?
      end

      ##
      # @return [Boolean] True if the current dialogue message has been fully
      #   printed.
      def current_done?
        @current_index == dialogue_queue.first.length - 1
      end

      ##
      # Moves onto the next dialogue message when the mouse is clicked.
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