require_relative '../entities/map'
require_relative '../entities/point'
require_relative 'controller'
require_relative 'dialogue_controller'
require_relative '../io/save_manager'

module ScenicRoute
  module Controllers
    ##
    # Handles invocation of map-drawing methods and responds to track change
    # controls.
    class MapController < Controller
      ##
      # The map which this controller is associated with.
      attr_reader :map

      ##
      # The point at which this map should be drawn.
      attr_reader :origin

      ##
      # Whether or not events should register on the map.
      attr_accessor :controls_enabled
      alias controls_enabled? controls_enabled

      ##
      # Create a new map controller.
      # 
      # @param [Entities::Map] map
      def initialize(map)
        super()

        load(map)
      end

      ##
      # Partially resets this map controller, overwriting the current map and 
      # assigning its controller to this. Controls are re-enabled and the
      # {DialogueController} is populated with dialogue from the map's metadata.
      #
      # @param [Entities::Map] map
      def load(map)
        @map = map
        map&.controller = self
        @drawing = false
        @removing = false
        @controls_enabled = true

        ControllerSupervisor.controller(DialogueController).dialogue_queue = \
          map.metadata.dialogue unless map.nil?
      end

      ##
      # The top-left corner of the map to be drawn.
      def origin
        Entities::Point.new(
          (Game::WIDTH - map.pixel_width) / 2,
          (Game::HEIGHT - map.pixel_height) / 2
        )
      end

      ##
      # Draws the map to the screen, and also draw any new track to the screen.
      def draw
        super
        return if map.nil?

        map.draw(origin.x, origin.y, 1)

        # Check where we were on the map
        tile_x = (mouse_point.x - origin.x) / map.tile_set.width
        tile_y = (mouse_point.y - origin.y) / map.tile_set.height

        if tile_x >= 0 && tile_x <= map.width && tile_y >= 0 && tile_y <= map.height
          tile_point = Entities::Point.new(tile_x.to_i, tile_y.to_i)

          if @drawing
            map.place_track(tile_point)
          elsif @removing
            map.remove_track(tile_point)
          end

          tile_corner_x = tile_x.to_i * map.tile_set.width + origin.x
          tile_corner_y = tile_y.to_i * map.tile_set.height + origin.y
        
          # TODO Colour based on validity
          Gosu.draw_rect(tile_corner_x, tile_corner_y, map.tile_set.width,
            map.tile_set.height, 0x77FFFF00, 10) if controls_enabled? 
        end

        # Draw the station colour indicators
        map.tile_objects.each do |obj|
          next unless obj.is_a?(Entities::StationObject)

          tile_corner_x = obj.point.x * map.tile_set.width + origin.x + 18
          tile_corner_y = obj.point.y * map.tile_set.height + origin.y + 10

          colour = Entities::StationObject::BACKGROUND_COLORS[obj.number]
          Gosu.draw_rect(tile_corner_x, tile_corner_y, 28, 22, colour, 9)
        end
      end

      ##
      # Handles the beginning of draw or remove track events.
      def button_down(id)
        super
        return unless controls_enabled?

        @drawing = true if id == Gosu::MsLeft
        @removing = true if id == Gosu::MsRight
      end

      ##
      # Handles the end of draw or remove track events.
      def button_up(id)
        super
        return unless controls_enabled?

        @drawing = false if id == Gosu::MsLeft
        @removing = false if id == Gosu::MsRight

        IO::SaveManager.save_map_state(map) if id == Gosu::KB_S
        IO::SaveManager.load_map_state(map) if id == Gosu::KB_L
      end
    end
  end
end
