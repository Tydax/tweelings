module Tweelings
  module Database
    ##
    # Class used to interact with the raw_tweet table.
    #
    # @author: Armand (Tydax) BOUR
    ##
    class DBRawTweets < DatabaseSQLiteCRUD

      TABLE  = "raw_tweet"
      ID     = "tweet_id"
      FIELDS = {
        id: "INTEGER",
        id_twitter: "INTEGER",
        theme: "VARCHAR(100)",
        author: "VARCHAR(50)",
        text: "VARCHAR(170)",
        date: "TEXT",
        criteria: "VARCHAR(150)",
        notation: "INTEGER"
      }

      def initialize
        super(

          )
      end
    end
  end
end