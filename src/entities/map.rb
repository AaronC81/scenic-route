require 'gosu'
require_relative 'point'
require_relative 'route'

module ScenicRoute
  module Entities
    ##
    # Represents a game map with routes drawn over it.
    class Map
      ##
      # An example map to demonstrate the layout required.
      EXAMPLE_MAP = [
        %I{scene_backdrop scene_backdrop scene_backdrop scene_backdrop scene_backdrop scene_backdrop scene_backdrop scene_backdrop},
        %I{scene_backdrop scene_backdrop scene_ground scene_ground scene_ground scene_ground scene_backdrop scene_backdrop},
        %I{scene_backdrop scene_ground scene_ground scene_ground scene_ground scene_ground scene_backdrop scene_backdrop},
        %I{scene_backdrop scene_backdrop scene_ground scene_ground scene_backdrop scene_ground scene_backdrop scene_backdrop},
        %I{scene_backdrop scene_backdrop scene_ground scene_backdrop scene_backdrop scene_ground scene_ground scene_backdrop},
        %I{scene_backdrop scene_backdrop scene_backdrop scene_backdrop scene_backdrop scene_backdrop scene_backdrop scene_backdrop}
      ]

      ##
      # @return [Array<Array<Symbol>>] A 2D array (row, col) of this map's 
      #   fixed layout, where each element is a tile name. This does not change
      #   as routes are drawn; elements are replaced with tracks when the map is
      #   drawn.
      attr_reader :layout

      ##
      # @return [Array<Route>] An array of the routes on this track.
      attr_reader :routes

      ##
      # @return [Tiles::TileSet] The tile set with which this map is drawn.
      attr_reader :tile_set

      ##
      # @return [Array<TileObject>] The tile objects on this map.
      attr_reader :tile_objects

      ## 
      # Create a new map.
      #
      # @param [Array<Array<Symbol>>] layout
      # @param [TileSet] tile_set
      def initialize(layout, tile_set)
        # TODO: validate maps
        @layout = layout
        @tile_set = tile_set
        @tile_objects = []
        @routes = []
      end

      ##
      # @return [Numeric] How many tiles wide this map is.
      def width
        layout.first.length
      end

      ##
      # @return [Numeric] How many tiles tall this map is.
      def height
        layout.length
      end

      ##
      # @return [Numeric] The pixel width of this map.
      def pixel_width
        width * tile_set.width
      end

      ##
      # @return [Numeric] The pixel height of this map.
      def pixel_height
        height * tile_set.height
      end

      ##
      # Place a track piece at a specific location, adjusing routes accordingly.
      #
      # @param [Point] point
      # @return [Boolean] True if the track piece was inserted, false otherwise.
      def place_track(point)
        # Check bounds and valid tile
        return false if point.x < 0 || point.x >= width 
        return false if point.y < 0 || point.y >= height
        return false unless tile_set.can_place_on?(layout[point.y][point.x]) && !tile_objects.map(&:point).include?(point)

        # Ensure this point doesn't already exist in a route
        return false if routes.flat_map(&:points).include?(point)

        inserted = false
        routes.each do |route|
          # If this point fits at either end of an existing route, add it and
          # leave the function
          if route.points.first.adjacent_to?(point)
            route.points.insert(0, point)
            inserted = true
            break
          elsif route.points.last.adjacent_to?(point)
            route.points << point
            inserted = true
            break
          end
        end

        # There was no existing route to integrate the point into; create a new
        # one instead
        routes << Route.new(self, [point]) unless inserted
        join_adjacent_routes
        true
      end

      ##
      # Removes a track piece from a specific location, adjusing routes
      # accordingly.
      #
      # @param [Point] point
      # @return [Boolean] True if the track piece was removed, false otherwise.
      def remove_track(point)
        # Remove the tile
        removed = false
        routes.each do |route|
          # If this point was removed from either end of a route, simply trim
          # the ends
          if route.points.length == 1 && route.points.first == point
            routes.delete(route)
            removed = true
            break
          elsif route.points.first == point
            route.points.delete_at(0)
            removed = true
            break
          elsif route.points.last == point
            route.points.delete_at(-1)
            removed = true
            break
          elsif route.points.include?(point)
            # If this point is on the route, but not at either end, then we
            # need to break the route into two
            before, after = route.points.slice_when { |x| x == point }.to_a
            before = before[0..-2] # removed the sliced point
            
            routes.delete(route)
            routes << Route.new(self, before)
            routes << Route.new(self, after)

            removed = true
            break
          end
        end

        return false unless removed
        join_adjacent_routes
        true
      end

      ##
      # Retrives the top-level tile at a given tile point. If there is an object
      # or a track at a point, that is returned, otherwise the layout tile is 
      # returned.
      #
      # @param [Point] point The point to return a tile for.
      #
      # @return [Symbol] A tile name.
      def tile_at(point)
        # TODO: Memoise these?
        route_tile_maps = routes.map(&:to_tile_hash).reduce(&:merge) || {}
        tile_object_maps = tile_objects.map { |o| [o.point, o] }.to_h

        if route_tile_maps[point]
          route_tile_maps[point]
        elsif tile_object_maps[point]
          tile_object_maps[point].tile_name
        else
          layout[point.y][point.x]
        end
      end

      ##
      # Scans through the routes on this map, consolidating ones which have
      # adjacent ends. This is called automatically after {place_track} and
      # {remove_track}.
      def join_adjacent_routes
        # The iteration must be restarted after each change for safety
        # Use a catch/throw and a variable to keep track of whether we need
        # to restart
        restart_required = false
        catch(:done) do
          routes.each do |a|
            routes.each do |b|
              if a != b && a.adjacent_to?(b)
                routes.delete(a)
                routes.delete(b)
                routes << a.join(b)

                # Trigger a retry
                restart_required = true
                throw(:done)
              end
            end
          end
        end

        join_adjacent_routes if restart_required
      end

      ## 
      # Draw this map and its routes onto the Gosu window.
      #
      # @param [Numeric] start_x The x position at which to start the map.
      # @param [Numeric] start_y The y position at which to start the map.
      # @param [Numeric] z The z position at which to draw the map.
      def draw(start_x, start_y, z)
        tile_set = Tiles::TileManager.tile_set(:world)

        width.times do |mx|
          height.times do |my|
            this_tile = tile_at(Point.new(mx, my))
            this_tile_x = tile_set.width * mx + start_x
            this_tile_y = tile_set.height * my + start_y
            tile_set.tile(this_tile).draw(this_tile_x, this_tile_y, z)
          end
        end
      end
    end 
  end
end