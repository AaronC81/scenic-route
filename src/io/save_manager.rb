require 'platform'
require 'fileutils'
require_relative '../entities/route'
require_relative '../entities/point'

module ScenicRoute
  module IO
    ##
    # Handles reading and writing routes for each map on the disc.
    class SaveManager
      ##
      # The comment written to the top of every save file.
      COMMENT = "Scenic Route save file. Don't edit this; The Conductor wouldn't be happy..."

      ##
      # @return [String] The root directory to which Scenic Route data should be
      #   saved.
      def self.save_directory_root
        case Platform::IMPL
        when :mswin, :mingw
          File.join(Dir.home, 'AppData', 'Roaming', 'ScenicRoute')
        when :linux
          File.join(Dir.home, '.local', 'share', 'scenic-route')
        when :macosx
          File.join(Dir.home, 'Library', 'ScenicRoute')
        else
          raise "unknown OS, so can't save data"
        end
      end

      ##
      # @return [String] The directory to which Scenic Route saves should be
      #   saved.
      def self.save_directory_saves
        File.join(save_directory_root, 'saves')
      end

      ##
      # Creates {save_directory_root} and {save_directory_saves} if they do
      #   not already exist.
      def self.ensure_save_directory_exists
        FileUtils.mkdir_p(save_directory_root)
        FileUtils.mkdir_p(save_directory_saves)
      end

      ##
      # Writes the routes currently plotted on a map to a file.
      #
      # @param [Entities::Map] map 
      def self.save_map_state(map)
        ensure_save_directory_exists

        save_path = File.join(save_directory_saves, "#{map.metadata.id}.srsav")

        # The first line of the save is ignored by the loader
        save_data = COMMENT

        # Place each route on a line afterwards
        map.routes.each do |route|
          save_data += ?\n + route.points.map { |pt| "#{pt.x},#{pt.y}" }.join(' ')
        end

        File.write(save_path, save_data)
      end

      ##
      # Reads routes from a file and plots them on an already-instantiated map.
      # Other routes are overwritten.
      #
      # @param [Entities::Map] map 
      def self.load_map_state(map)
        save_path = File.join(save_directory_saves, "#{map.metadata.id}.srsav")

        save_lines = File.read(save_path).split(?\n)[1..-1] rescue []

        map.routes = save_lines.map do |l|
          Entities::Route.new(map, l.split.map do |pt|
            Entities::Point.new(*pt.split(',').map(&:to_i))
          end)
        end
      end
    end
  end
end