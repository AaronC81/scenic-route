require_relative "../entities/map"

module ScenicRoute
  module IO
    ##
    # Creates {Map} instances from sclay files.
    class MapLoader
      ##
      # The characters found in a layout file, mapped to the tile symbols they
      # represent.
      CHAR_LOOKUP = {
        ?# => :scene_ground,
        ?. => :scene_backdrop
      }

      ##
      # Converts a string to a layout.
      #
      # @param [String] string
      #
      # @return [Array<Array<Symbol>>] The layout.
      def self.convert_layout(string)
        string.split(?\n).map do |line|
          line.chars.map do |char|
            sym = CHAR_LOOKUP[char]
            raise 'invalid character in layout' if sym.nil?
            sym
          end
        end
      end

      def self.convert_objects(string)
        string.split(?\n).map do |line|
          object_name, *parameters = line.split
          Entities.const_get(object_name).new(*parameters.map do |param|
            if param.include?(?,)
              Entities::Point.new(*param.split(?,).map(&:to_i))
            elsif param.include?(?.)
              param.to_f
            elsif param.start_with?(?:)
              param[1..-1].to_sym
            else
              param.to_i
            end
          end)
        end
      end

      def self.load_map(filename, tile_set)
        contents = File.read(filename)
        layout_str, objects_str = contents.split("\n---\n")

        map = Entities::Map.new(convert_layout(layout_str), tile_set)
        map.tile_objects.append(*convert_objects(objects_str))

        p map.tile_objects

        map
      end
    end
  end
end