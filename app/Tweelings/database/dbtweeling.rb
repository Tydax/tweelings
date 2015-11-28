module Tweelings
  module Database
    ##
    # Class used to interact with the tweeling table.
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

      ##
      # Initialises a new instance of the database object with the specific requests.
      ##
      def initialize
        super(TABLE, ID, FIELDS)

        REQUESTS[:fetch_uncleaned] = REQUESTS[:fetch] % " WHERE cleaned_text IS NULL %s"
        REQUESTS[:fetch_unverified] = REQUESTS[:fetch] % " WHERE verified = '0' %s" 
      end

      ##
      # Calls the specified request passing the specified argument.
      #
      # @param req [String] the SQL request to execute
      # @param arg [String] the argument to pass to the request
      # @returns [Array<Object>, nil] an array containing the converted fetched object(s) using #from_row,
      #   or nil if the request failed
      ##
      def basic_fetch(req, arg)
        res = nil

        begin
          db = SQLite3::Database.new(DB_PATH, DB_OPTIONS)
          res = []
          db.prepare(req) do |stmt|
            stmt.execute(arg) do |row|
              res << from_row(row)
            end
          end
        rescue SQLite3::SQLException => e
          # @todo Log the exception
          puts "[Error][DBTweeling::fetch] Error code #{e.code}"
          res = nil
        ensure
          db.close if db
        end

        res
      end

      ##
      # Fetches the tweelings corresponding to the specified theme.
      #
      # @param theme [String] the theme to fetch
      # @returns [Array<Object>, nil] an array containing the converted fetched object(s) using #from_row,
      #   or nil if the request failed
      ##
      def fetch_theme(theme)
        res = nil

        if theme
          req = REQUESTS[:fetch] % " WHERE theme = ?"
          res = basic_fetch(req, theme)
        end

        res
      end

      ##
      # Fetches the uncleaned tweelings corresponding to the theme if specified.
      #
      # @param theme [String] the theme to fetch (optional)
      # @returns [Array<Object>, nil] an array containing the converted fetched object(s) using #from_row,
      #   or nil if the request failed
      ##
      def fetch_uncleaned(theme = nil)
        req = REQUESTS[:fetch_uncleaned] % (theme ? "AND theme = ?" : "")
        basic_fetch(req, theme)
      end

      ##
      # Fetches the unverified tweelings correspond to the theme if specified.
      #
      # @param theme [String] the theme to fetch (optional)
      # @returns [Array<Object>, nil] an array containing the converted fetched object(s) using #from_row,
      #   or nil if the request failed
      ##
      def fetch_unverified(theme = nil)
        req = REQUESTS[:fetch_unverified] % (theme ? "AND theme = ?" : "")
        basic_fetch(req_theme)
      end

      private :basic_fetch
    end
  end
end