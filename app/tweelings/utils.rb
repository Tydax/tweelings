# Base libraries
require 'csv'

# Downloaded libraries
require 'twitter'

##
# Utils offers functions used to all kind of utility purpose.
class Utils

    ## Default tweet database file path
    @@database_path = 'data/database.csv'
    @@tweet_cache = nil # We might actually not need that in the future, but for now, we'll just keep it

    ##
    # Converts the file to 
    def self.convert_to_csv(tweet_cache, criteria, database_path = @@database_path)
        CSV.open(@@database_path, 'ab') do |csv|
            tweet_cache.each do |tweet|
                csv << [tweet.id, tweet.user.screen_name, tweet.text, tweet.created_at, request_from_criteria(criteria)]
            end
        end
    end

    def self.request_from_criteria(criteria)
        res = "#{criteria[:word]}"
        return res
    end
end