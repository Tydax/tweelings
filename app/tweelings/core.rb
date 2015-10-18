
# My libraries
require 'tweelings/algorithm'
require 'tweelings/twitterclient'
require 'tweelings/utils'


class Core

    @@twitter_client = TwitterClient.new('config/app_config.yaml')
    @@database = DatabaseCSV.new

    ##
    # Caches to store pending tweets 
    @@raw_cache
    @@converted_cache
    @@cleaned_cache

    def self.fetch_tweets(criteria)
        @@raw_cache = @@twitter_client.fetch_tweets(criteria)
        @@raw_cache
    end

    def self.convert_tweets
        @@converted_cache = []
        @@raw_cache.each do |raw_tweet|
            @@.converted_cache.push(Tweeling.from_raw(raw_tweet))
        end
        @@database.save(@@converted_cache, @@database.def_raw_db)
        @@converted_cache
    end

    def self.clean_tweets
        @@cleaned_cache = []

        @@converted_cache.each do |tweeling|
            Algorithm.clean_tweet!(tweeling.text)
            @@cleaned_cache.push(tweeling)
        end
        @@database.save(@@cleaned_cache, @@database.def_clean_db)
        @@cleaned_cache
    end
end