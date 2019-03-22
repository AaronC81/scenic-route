module ScenicRoute
  module IO
    MapMetadata = Struct.new('MapMetadata', :name, :medal_thresholds) do
      def bronze_threshold
        medal_thresholds[0]
      end

      def silver_threshold
        medal_thresholds[1]
      end

      def gold_threshold
        medal_thresholds[2]
      end

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