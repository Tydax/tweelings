module Tweelings
  module Database
    ##
    # Class used to interact with the raw_tweet table.
    #
    # @author: Armand (Tydax) BOUR
    ##
    class DBTweeling < DatabaseSQLiteCRUD

      TABLE  = :tweeling
      ID     = :id
      FIELDS = [
        id:,
        id_twitter:,
        theme:,
        author:,
        text:,
        cleaned_text:
        date:,
        criteria:,
        notation:,
        verified:
      ]

      def initialize
        super(TABLE, ID, FIELDS)

        REQUESTS[:fetch_uncleaned] = REQUESTS[:fetch] % " WHERE cleaned_text IS NULL %s"
        REQUESTS[:fetch_unverified] = REQUESTS[:fetch] % " WHERE verified = '0' %s" 
      end

      def fetch_theme(theme)
        res = nil
        if theme
          req = REQUESTS[:fetch] % " WHERE theme = ?"
          
        end

        res
      end

      def fetch_uncleaned(theme = nil)
      end
    end
  end
end