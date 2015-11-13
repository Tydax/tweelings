module Tweelings
  module TweelingsCore
    module Core
      TWITTER_CLIENT = Tweelings::Client::TwitterRESTClient.new('config/app_config.yaml')
      DATABASE = Tweelings::Database::DatabaseCSV

      ##
      # Caches to store pending tweets 
      @@raw_cache
      @@converted_cache
      @@cleaned_cache

      def self.fetch_tweets(criteria)
        @@raw_cache = TWITTER_CLIENT.fetch_tweets(criteria)
      end

      def self.convert_tweets
        @@converted_cache = []
        @@raw_cache.each do |raw_tweet|
            @@converted_cache.push(Tweelings::Object::Tweeling.from_raw(raw_tweet))
        end
        DATABASE.save(@@converted_cache, DATABASE.def_raw_db)
        @@converted_cache
      end

      def self.clean_tweets
        @@cleaned_cache = []

        @@converted_cache.each do |tweeling|
            Algorithm.clean_tweet!(tweeling.text)
            @@cleaned_cache.push(tweeling)
        end
        DATABASE.save(@@cleaned_cache, DATABASE.def_clean_db)
        @@cleaned_cache
      end
    end
  end
end