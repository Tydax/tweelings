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
        cache.size
      end

      def self.clean_tweets        
        cache = DATABASE.fetch(*@@indexes)
        cache.each { |tweeling| tweeling.cleaned_text = Tweelings::Business::Algorithm.clean_tweet(tweeling.text) }
        DATABASE.update(*cache)
      end

      def self.annotate_tweets(algorithm, param)
        cache = DATABASE.fetch(*@@indexes)

        case algorithm
        when "Lexique"
          cache.each do |tweeling|
            tweeling.notation = Tweelings::Business::Algorithm.annotate_using_keywords(tweeling.text)
          end
        when "KNN"
          cache.each do |tweeling|
            base = DATABASE.fetch_verified
            tweeling.notation = Tweelings::Business::Algorithm.annotate_using_knn(text, base, param)
          end
        else
          puts "[Tweelings_Core]["
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

      def self.get_base(theme = nil)
        DATABASE.fetch_verified(theme)
      end
    end
  end
end
