module ScenicRoute
  module IO
    ##
    # The metadata associated with a {Entities::Map}.
    MapMetadata = Struct.new('MapMetadata', :name, :id, :medal_thresholds, :dialogue) do
      # @!attribute name
      #   @return [String] The user-facing name of this map.

      # @!attribute id
      #   @return [String] The unique ID for this map.

      # @!attribute medal_thresholds
      #   @return [Array<Integer>] An array of medal thresholds in the order
      #     [bronze, silver, gold].
      
      # @!attribute dialogue
      #   @return [Array<String>] The dialogue queue spoken by The Conductor
      #     before this map begins.

      ##
      # @return [Integer] The score threshold for a bronze medal.
      def bronze_threshold
        medal_thresholds[0]
      end

      ##
      # @return [Integer] The score threshold for a silver medal.
      def silver_threshold
        medal_thresholds[1]
      end

      ##
      # @return [Integer] The score threshold for a gold medal.
      def gold_threshold
        medal_thresholds[2]
      end

      ##
      # Given a score, returns the medal which will be awarded for the score.
      #
      # @param [Integer] score
      # @return [Symbol?] Either :bronze, :silver, :gold, or nil for no medal.
      def medal_for(score)
        if score >= gold_threshold
          :gold
        elsif score >= silver_threshold
          :silver
        elsif score >= bronze_threshold
          :bronze
        else
          nil
        end
      end
    end
  end
end