# Base libraries
require 'csv'

# My libraries
require 'tweelings/utils'

##
# Module used for interactions with the .csv files.
#
# Author:: Armand (Tydax) BOUR
module DatabaseCSV

    @@def_raw_db_path = 'data/database.csv'
    @@def_cleaned_db_path = ''

    ##
    # Saves the specified tweets into the specified CSV file.
    # tweeling_cache: The tweeling cache hash containing a hash for each tweeling containing all the information
    # database_path: The path to the .csv file where the tweelings must be saved.
    def save(tweeling_cache, database_path)
        CSV.open(database_path, 'ab') do |csv|
            tweeling_cache.each do |tweeling|
                csv << tweeling.to_a
            end
        end
    end

    ##
    # Fetches all the tweet from the specified csv file.
    # database_path: The path to the .csv file containing the tweets.
    def fetch_all(database_path)
        return fetch_theme(database_path, nil)
    end

    ##
    # Fetches all the tweet from the specified csv file.
    # database_path: The path to the .csv file containing the tweets.
    # theme: 
    def fetch_theme(database_path, theme)
        # Store in a array
        result = []
        CSV.foreach(database_path) do |row|
            \
            if theme == nil || theme == row[1]
                tweet = Tweeling.from_a(row)
                result.push(tweet)
            end
        end
        return result
    end

    def self.csv_to_tweet
end