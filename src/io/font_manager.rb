require_relative '../ui/controller_supervisor'

module ScenicRoute
  module IO
    ##
    # Loads and memoises the fonts used.
    class FontManager
      ##
      # Holds loaded fonts.
      @@loaded_fonts = {}

      ##
      # The path to the Silkscreen font's TTF file.
      SILKSCREEN_PATH = './res/font/Silkscreen.ttf'

      ##
      # Loads Silkscreen from {SILKSCREEN_PATH} at a particlar font size, and
      # memoises the result.
      #
      # @param [Numeric] size
      # @return [Gosu::Font] 
      def self.font(size)
        @@loaded_fonts[size] ||= Gosu::Font.new(UI::ControllerSupervisor.window,
          SILKSCREEN_PATH, size)
      end
    end
  end
end