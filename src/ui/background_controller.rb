require 'gosu'
require_relative 'controller'
require_relative 'map_controller'
require_relative 'controller_supervisor'

module ScenicRoute
  module UI
    ##
    # Handles drawing a background to the window.
    class BackgroundController < Controller
      def draw
        # Calculate offset so that tiles align with map
        map_origin = ControllerSupervisor.controller(MapController).origin

        offset_x = -(map_origin.x % map.tile_set.width)
        offset_y = -(map_origin.y % map.tile_set.height)

        (Game::WIDTH / map.tile_set.width + 1).times do |tx|
          (Game::HEIGHT / map.tile_set.height + 1).times do |ty|
            map.tile_set.tile(:scene_backdrop).draw(
              offset_x + tx * map.tile_set.width,
              offset_y + ty * map.tile_set.height, 0)
          end
        end
      end
    end
  end
end