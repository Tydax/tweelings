module Tweelings
  module TweelingsCore
    module Core

      # Dummy mode
      #TWITTER_CLIENT = Tweelings::Client::DummyTwitter.new('data/sncf.yaml')
      TWITTER_CLIENT = Tweelings::Client::TwitterREST.new('config/app_config.yaml')
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
            tweeling.notation = Tweelings::Business::Algorithm.annotate_using_knn(tweeling.text, base, Integer(param))
          end
        when "Bayes"
          base = DATABASE.fetch_verified
          Tweelings::Business::Algorithm.annotate_using_bayes(@@cache, base)
        else
          puts "[Tweelings_Core][Error] Invalid value for algorithm, skipping."
          return nil
        end

        Array.new(@@cache)
      end

      def self.update_tweets(hashes)
        hashes.each do |hash|
          tweet = @@cache.select { |tweeling| tweeling.id == hash[:id] }.first
          tweet.notation = hash[:notation]
          tweet.verified = true
        end

        cache_temp = []
        @@cache.each do |tweet|
          cache_temp << Tweelings::Object::Tweeling.new(tweet.to_h)
        end

        cache_temp.each do |tweet_temp|
          tweet_temp.id = nil
        end

        DATABASE.save(*cache_temp)
        DATABASE.update_annotation(*cache_temp.select { |tweeling| !tweeling.id })
      end

      def self.get_base(theme = nil)
        DATABASE.fetch_verified(theme)
      end
    end
  end
end
