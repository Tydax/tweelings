module Tweelings
  module Database
    ##
    # Example class
    class DBRawTweets
      FIELDS = [
        'tweet_id',
        'id_twitter',
        'theme',
        'author',
        'text',
        'date',
        'criteria',
        'notation'
      ]

      TABLE = 'raw_tweets'

      ID = 'tweet_id'

      include Tweelings::Database::DatabaseSQLite

      def from_row
      end

      def to_row
      end
    end
  end
end