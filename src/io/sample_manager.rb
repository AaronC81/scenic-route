require 'gosu'

module ScenicRoute
  module IO
    ##
    # Handles loading samples from files through symbolic sample names.
    class SampleManager
      ##
      # A map of sample symbols to their filepaths.
      SAMPLE_PATHS = {
        hover: 'res/sound/hover.wav',
        place: 'res/sound/place.wav',
        select1: 'res/sound/select1.wav',
        select2: 'res/sound/select2.wav',
        track_complete: 'res/sound/track_complete.wav',
        speak: 'res/sound/speak.wav',
        remove: 'res/sound/remove.wav'
      }

      ##
      # Holds already loaded samples.
      MEMOIZED_SAMPLES = {}

      ##
      # Loads an sample from a file given its symbolic name, which must be a key
      # in {SAMPLE_PATHS}.
      #
      # @param [Symbol] name
      # @return [Gosu::Sample]
      def self.sample(name)
        sample_path = SAMPLE_PATHS[name]
        raise 'no such sample' if sample_path.nil?

        (MEMOIZED_SAMPLES[name] ||= Gosu::Sample.new(sample_path))
      end
    end
  end
end
