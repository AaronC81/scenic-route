module ScenicRoute
  module IO
    ##
    # Creates arrays in a suitable format for {Entities::Map#layout} from 
    # files.
    class LayoutLoader
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

      ##
      # Loads a layout from a filepath and converts it to a layout.
      #
      # @param [String] string
      #
      # @return [Array<Array<Symbol>>] The layout.
      def self.load_layout(filepath)
        convert_layout(File.read(filepath))
      end
    end
  end
end