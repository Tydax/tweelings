module Tweelings
  module Database
    ##
    # Base module ccontaing the base methods to interact with the database.
    # A few constants and methods must be defined when this module is included in a class:
    #   * #FIELDS a [Array<String>] containing all the name of the fields of the table
    #   * #TABLE a [String] representing the name of the table
    #   * #ID a [String] representing the name of the column corresponding to the index
    #   * #from_row method that converts the row to an object
    #   * #to_row method that converts the object to an hash
    #
    # @author: Armand (Tydax) BOUR
    ##
    module DatabaseSQLite

      DEFAULT_FIELDS = []
      DEFAULT_TABLE = ''
      DEFAULT_ID = ''

      DB_PATH = 'data/database.db'
      FIELDS_JOINED = FIELDS.join(', ')

      ## Requests
      REQ_FETCH  = "SELECT #{FIELDS_JOINED} FROM #{TABLE}"
      REQ_SAVE   = "INSERT INTO #{TABLE} (#{FIELDS_JOINED}) VALUES (#{FIELDS_JOINED.map { |e| ':' << e}};"
      REQ_DELETE = "DELETE FROM #{TABLE} WHERE #{ID} IN("
      REQ_UPDATE = "UPDATE #{TABLE} SET #{FIELDS.map { |e| e + ' = :' + e if e != ID}}.join(',\n') WHERE #{ID} = #{':' << ID};"

      def self.included(base)
        # Define default constant for FIELDS
        unless base.cons_defined?(:FIELDS)
          base.const_set(:FIELDS, DEFAULT_FIELDS)
        end

        # Define default constant for TABLE
        unless base.cons_defined?(:TABLE)
          base.const_set(:TABLE, DEFAULT_TABLE)
        end

        # Define default constant for ID
        unless base.cons_defined?(:ID)
          base.const_set(:ID, DEFAULT_ID)
        end
      end

      ##
      # Retrieves all the rows.
      #
      # @param index [Integer, nil] the index of the row to fetch
      #   if nil, all rows will be fetched
      # @returns [Array<Object>, nil] an array of the rows converted to objects
      #   or nil if an exception occured.
      ##
      def fetch(index = nil)
        req = REQ_FETCH +
          (index ? " WHERE #{ID} = ?;" : ";")
        res = []

        begin
          db = SQLite3::Database.new(DB_PATH)
          db.execute(req, index) do |row|
            res.push(from_row(row))
          end
        rescue SQLException => e
          # @todo Log the exception
          puts "[Error][DatabaseSQLite::fetch] Error code #{e.code}"
          res = nil
        ensure
          db.close
        end

        res
      end

      ##
      # Inserts a new row.
      #
      # @param [Array<Object>] object the object to be inserted
      # @returns [true, false] whether the request succeeded or not
      ##
      def save(*objects)
        req = REQ_SAVE

        begin
          db = SQLite3::Database.new(DB_PATH)
          db.prepare(req) do |stmt|
            objects.each do |obj|
              stmt.bind_params(to_row(obj))
              stmt.execute
            end
          end
          true
        rescue SQLException => e
          # @todo Log the exception
          puts "[Error][DatabaseSQLite::save] Error code #{e.code}"
          false
        ensure
          db.close
        end
      end

      ##
      # Deletes the rows with the specified indexes.
      #
      # @param [Array<Integer>] index the index(es) of the rows to delete
      # @returns [true, false] whether the request succeeded or not
      ##
      def delete(*indexes)
        req = REQ_DELETE + Array.new(indexes.count, '?').join(', ') + ");"

        begin
          db = SQLite3::Database.new(DB_PATH)
          db.prepare(req, indexes)
          true
        rescue SQLException => e
          # @todo Log the exception
          puts "[Error][DatabaseSQLite::save] Error code #{e.code}"
          false
        ensure
          db.close
        end
      end

      ##
      # Updates the rows corresponding to the specified object.
      # @param [Object] object the object to update
      # @returns [true, false] whether the request succeeded or not
      ##
      def update(object)
        req = REQ_UPDATE

        begin
          db = SQLite3::Database.new(DB_PATH)
          db.execute(req, to_row(object))
        rescue SQLException => e
          # @todo Log the exception
          puts "[Error][DatabaseSQLite::save] Error code #{e.code}"
          false
        ensure
          db.close
        end
      end
    end
  end
end
