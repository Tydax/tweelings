module Tweelings
  module TweelingsCore
    module Core

      TWITTER_CLIENT = Tweelings::Client::DummyTwitter.new('data/sncf.yaml')
      DATABASE = Tweelings::Database::DatabaseCSV

      ##
      # Caches to store pending tweets 
      @@raw_cache
      @@criteria_cache
      @@converted_cache
      @@cleaned_cache

      def self.fetch_tweets(criteria)
        @@criteria_cache = criteria
        @@raw_cache = TWITTER_CLIENT.fetch_tweets(criteria)
      end

      def self.convert_tweets
        @@converted_cache = []
        @@raw_cache.each do |raw_tweet|
          @@converted_cache.push(Tweelings::Object::Tweeling.from_raw(raw_tweet, @@criteria_cache))
        end
        #DATABASE.save(@@converted_cache, DATABASE::DEF_RAW_DB)
        @@converted_cache
      end

      def self.clean_tweets
        @@cleaned_cache = []

        @@converted_cache.each do |tweeling|
            tweeling.text = Tweelings::Business::Algorithm.clean_tweet(tweeling.text)
            @@cleaned_cache.push(tweeling)
        end
        #DATABASE.save(@@cleaned_cache, DATABASE::DEF_CLEANED_DB)
        @@cleaned_cache
      end
    end
  end
end
