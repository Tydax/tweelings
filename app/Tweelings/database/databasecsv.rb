module Tweelings
  module Database
    ##
    # Module used for interactions with the .csv files.
    #
    # @author Armand (Tydax) BOUR
    ##
    module DatabaseCSV

      DEF_RAW_DB = 'data/db_raw.csv'
      DEF_CLEANED_DB = 'data/db_cleaned.csv'

      ##
      # Saves the specified tweets into the specified CSV file.
      # tweeling_cache: The tweeling cache hash containing a hash for each tweeling containing all the information
      # database_path: The path to the .csv file where the tweelings must be saved.
      def self.save(tweeling_cache, database_path)
        # If no index are defined in the tweelings, fetch the last index to generate one (case specific to raw tweet)
        if tweeling_cache.first.id == -1
          index = 0
          if File.exist?(database_path)
            base = CSV.read(database_path)
            if !base.empty?
              index = base.last.first.to_i + 1
            end
            puts index
          end

          tweeling_cache.each do |tweeling|
              tweeling.id = index
              index += 1
          end
        end

        CSV.open(database_path, 'ab') do |csv|
          tweeling_cache.each do |tweeling|
              csv << tweeling.to_a
          end
        end
      end

      ##
      # Fetches all the tweet from the specified csv file.
      # database_path: The path to the .csv file containing the tweets.
      def self.fetch_all(database_path)
        fetch_theme(database_path)
      end

      ##
      # Fetches all the tweet from the specified csv file.
      # database_path: The path to the .csv file containing the tweets.
      # theme: 
      def self.fetch_theme(database_path, theme = nil)
        # Store in a array
        result = []
        CSV.foreach(database_path) do |row|
          # Fetch all if no theme was defined
          if theme == nil || theme == row[1]
            tweet = Tweeling.new(*row)
            result.push(tweet)
          end
        end
        result
      end
    end
  end
end
