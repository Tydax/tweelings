module Tweelings
  module TweelingsCore
    module Core

      TWITTER_CLIENT = Tweelings::Client::DummyTwitter.new('data/sncf.yaml')
      DATABASE = Tweelings::Database::DBTweeling.new

      ##
      # Caches to store pending tweets 
      @@indexes

      def self.fetch_tweets(criteria)
        cache = []
        TWITTER_CLIENT.fetch_tweets(criteria).each do |raw_tweet|
          cache << Tweelings::Object::Tweeling.from_raw(raw_tweet, criteria)
        end
        DATABASE.save(*cache)
        # Store indexes saved
        @@indexes = cache.each_with_object([]) { |tweeling, a| a << tweeling.id if tweeling.id }
        cache
      end

      def self.clean_tweets        
        cache = DATABASE.fetch(*@@indexes)
        cache.each { |tweeling| tweeling.cleaned_text = Tweelings::Business::Algorithm.clean_tweet(tweeling.text) }
        DATABASE.update(*cache)
      end

      def self.annotate_tweets
        cache = DATABASE.fetch(*@@indexes)
        cache.each { |tweeling| tweeling.notation = Tweelings::Business::Algorithm.annotate_using_keywords(tweeling.text) }
        DATABASE.update(*cache)
        # @todo delete this line
        DATABASE.delete(*@@indexes)
        cache
      end
    end
  end
end
