module Tweelings
  module Database
    ##
    # Base module ccontaing the base methods to interact with the database.
    # A few constants and methods must be defined when this module is included in a class:
    #   * #FIELDS a [Array<String>] containing all the name of the fields of the table
    #   * #TABLE a [String] representing the name of the table
    #   * #from_row method that converts the row to an object
    #   * #to_row method that converts the object to an hash
    #
    # @author: Armand (Tydax) BOUR
    ##
    module DatabaseSQLite

      DB = SQLITE3::Database.new("data/database.db")

      FIELDS_JOINED = FIELDS.join(', ')

      ##
      # Retrieves all the rows.
      #
      # @param index [Integer, nil] the index of the row to fetch
      #   if nil, all rows will be fetched
      # @returns [Array<Object>, nil] an array of the rows converted to objects
      #   or nil if an exception occured.
      ##
      def fetch(index = nil)
        req = "SELECT #{FIELDS_JOINED} FROM #{TABLE}" +
          (index ? " WHERE index = ?" : "")
        res = []

        begin
          DB.execute(req, index) do |row|
            res.push(from_row(row))
          end
        rescue SQLException => e
          # @todo Log the exception
          puts "[Error][DatabaseSQLite::fetch] Error code #{e.code}"
          res = nil
        end

        res
      end

      ##
      # Inserts a new row.
      #
      # @param [Object] object the object to be inserted
      # @returns [true, false] whether the row has been inserted or not
      ##
      def save(object)
        req = "INSERT INTO #{TABLE} (#{FIELDS_JOINED})"\
          " VALUES (#{FIELDS_JOINED.map { |e| ':' << e}}"

        begin
          DB.execute(req, to_row(object))
          true
        rescue SQLException => e
          # @todo Log the exception
          puts "[Error][DatabaseSQLite::save] Error code #{e.code}"
          false
        end
      end
    end
  end
end
