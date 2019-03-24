require 'platform'
require 'fileutils'
require_relative '../entities/route'
require_relative '../entities/point'

module ScenicRoute
  module IO
    class SaveManager
      COMMENT = "Scenic Route save file. Don't edit this; The Conductor wouldn't be happy..."

      def self.save_directory_root
        case Platform::IMPL
        when :mswin
          File.join(Dir.home, 'AppData', 'Roaming', 'ScenicRoute')
        when :linux
          File.join(Dir.home, '.local', 'share', 'scenic-route')
        when :macosx
          File.join(Dir.home, 'Library', 'ScenicRoute')
        else
          nil
        end
      end

      def self.save_directory_saves
        File.join(save_directory_root, 'saves')
      end

      def self.ensure_save_directory_exists
        FileUtils.mkdir_p(save_directory_root)
        FileUtils.mkdir_p(save_directory_saves)
      end

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