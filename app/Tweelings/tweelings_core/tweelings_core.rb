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

      def self.annotate_tweets(algorithm)
        cache = DATABASE.fetch(*@@indexes)

        if algorithm == "Lexique"
          cache.each { |tweeling| tweeling.notation = Tweelings::Business::Algorithm.annotate_using_keywords(tweeling.text) }
        elsif algorithm == "KNN"
          cache.each { |tweeling| tweeling.notation = Tweelings::Business::Algorithm.annotate_using_knn(text, base, neighbours) }
        else
          # ERROR
        end

        DATABASE.update(*cache)
        cache
      end

      def self.update_tweets(hashes)
        hashes.each { |hash| hash[:verified] = true }
        DATABASE.update_annotation(*hashes)
        # @todo delete this line
        # DATABASE.delete(*@@indexes)
      end

      def self.get_base
        DATABASE.fetch_verified(theme)
      end
    end
  end
end
