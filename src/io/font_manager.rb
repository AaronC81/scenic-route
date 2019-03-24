require_relative '../ui/controller_supervisor'

module ScenicRoute
  module IO
    class FontManager
      @@loaded_fonts = {}

      SILKSCREEN_PATH = './res/font/Silkscreen.ttf'

      def self.font(size)
        @@loaded_fonts[size] ||= Gosu::Font.new(UI::ControllerSupervisor.window,
          SILKSCREEN_PATH, size)
      end
    end
  end
end