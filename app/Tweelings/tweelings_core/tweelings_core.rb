module Tweelings
  module TweelingsCore
    module Core

      TWITTER_CLIENT = Tweelings::Client::DummyTwitter.new('data/sncf.yaml')
      DATABASE = Tweelings::Database::DBTweeling.new

      ##
      # Caches to store pending tweets 
      @@cache

      def self.fetch_tweets(criteria)
        @@cache = []
        nb = 0
        TWITTER_CLIENT.fetch_tweets(criteria).each do |raw_tweet|
          tweet = Tweelings::Object::Tweeling.from_raw(raw_tweet, criteria)
          tweet.id = nb
          nb += 1
          @@cache << tweet
        end
        @@cache.size
      end

      def self.clean_tweets        
        @@cache.each { |tweeling| tweeling.cleaned_text = Tweelings::Business::Algorithm.clean_tweet(tweeling.text) }
      end

      def self.annotate_tweets(algorithm, param)
        case algorithm
        when "Lexique"
          @@cache.each do |tweeling|
            tweeling.notation = Tweelings::Business::Algorithm.annotate_using_keywords(tweeling.text)
          end
        when "KNN"
          @@cache.each do |tweeling|
            base = DATABASE.fetch_verified
            tweeling.notation = Tweelings::Business::Algorithm.annotate_using_knn(text, base, param)
          end
        else
          puts "[Tweelings_Core]["
        end

        Array.new(@@cache)
      end

      def self.update_tweets(hashes)
        hashes.each do |hash|
          tweet = @@cache.select { |tweeling| tweeling.id == hash[:id] }.first
          tweet.notation = hash[:notation]
          tweet.verified = true
        end
        DATABASE.save(*@@cache)
      end

      def self.get_base(theme = nil)
        DATABASE.fetch_verified(theme)
      end
    end
  end
end
