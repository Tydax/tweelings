module Tweelings
  module Database
    ##
    # Base class representing the object to interact with the database.
    # Each instance is used to interact with a specific table.
    #
    # @author: Armand (Tydax) BOUR
    ##
    class DatabaseSQLiteCRUD

      # Path to the database file.
      DB_PATH = 'data/database.db'
      # Options used to initialise the database object.
      DB_OPTIONS = {
        results_as_hash: true,
        type_translation: true
      }

      # Constants holding the requests
      REQUESTS = {}
      
      ##
      # Initialises a new CRUD object to interact with the specified table.
      #   Creates the SQL table if it does not exist. 
      #
      # @param tablename [String] the name of the table
      # @param id [String] the name of the field representing the id
      # @param fields [Hash<Symbol, String>] the hash containing the field name in Symbol as the keys and the SQL type String as the value 
      ##
      def initialize(tablename, id, fields)
        @table = tablename
        @id = id
        @fields = fields.keys.map { |e| e.to_s }
        @fields_joined = @fields.join(', ')
        
        keys = fields.keys.map { |e| ':' + e.to_s }

        ## Requests
        REQUESTS[:fetch]  = "SELECT #{@fields_joined} FROM #{@table} %s;"
        REQUESTS[:save]   = "INSERT INTO #{@table} (#{@fields_joined}) VALUES (#{keys.join(', ')});"
        REQUESTS[:delete] = "DELETE FROM #{@table} WHERE #{@id} IN(%s);"
        
        # Creating a "id = :id" formated string
        f = []
        @fields.zip(Array.new(@fields.count, ' = '), keys) { |e| f.push(e.join) }
        REQUESTS[:update] = "UPDATE #{@table} SET #{f.join(', ')} WHERE #{@id} = #{':' << @id};"

        f = []
        fields.each { |key, value| f << "#{key.to_s} #{value}" + (key.to_s == id ? " PRIMARY KEY" : "") }
        req = "CREATE TABLE IF NOT EXISTS #{tablename} (%s);" % f.join(", ")

        binding.pry

        begin
          db = SQLite3::Database.new(DB_PATH, DB_OPTIONS)
          db.execute(req)
        rescue SQLite3::SQLException => e
          # @todo Log the exception
          puts "[Error][DatabaseSQLiteCRUD::fetch] Error code #{e.code}"
          raise "Failed to initialise DatabaseSQLiteCRUD object"
        ensure
          db.close
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
        req = REQUESTS[:fetch] % (index ? " WHERE #{@id} = ?" : "")
        res = []

        begin
          db = SQLite3::Database.new(DB_PATH)
          db.execute(req, index) do |row|
            res.push(from_row(row))
          end
        rescue SQLite3::SQLException => e
          # @todo Log the exception
          puts "[Error][DatabaseSQLiteCRUD::fetch] Error code #{e.code}"
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
        req = REQUESTS[:save]

        begin
          db = SQLite3::Database.new(DB_PATH)
          db.prepare(req) do |stmt|
            objects.each do |obj|
              stmt.execute(to_row(obj))
            end
          end
          true
        rescue SQLite3::SQLException => e
          # @todo Log the exception
          puts "[Error][DatabaseSQLiteCRUD::save] Error code #{e.code}"
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
        req = REQUESTS[:delete] % Array.new(indexes.count, '?').join(', ')
        
        begin
          db = SQLite3::Database.new(DB_PATH)
          db.prepare(req) { |stmt| stmt.execute(indexes) }
          true
        rescue SQLite3::SQLException => e
          # @todo Log the exception
          puts "[Error][DatabaseSQLiteCRUD::delete] Error code #{e.code}"
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
        req = REQUESTS[:update]

        begin
          db = SQLite3::Database.new(DB_PATH)
          db.execute(req, to_row(object))
        rescue SQLite3::SQLException => e
          # @todo Log the exception
          puts "[Error][DatabaseSQLiteCRUD::update] Error code #{e.code}"
          false
        ensure
          db.close
        end
      end

      ##
      # Default implementation of the method used to transform an object into a hash.
      # Called by #save and #update.
      #
      # @param object [#to_h] the object to transform
      # @returns [Hash<String, Object>] a hash containing the column name as keys and the attributes of the object as values.
      ##
      def to_row(object)
        object.to_h.each_key { |key| key.to_s }
      end

      ##
      # Default implementation of the method used to transform a row into an object.
      # Called by #fetch.
      #
      # @param row [Hash] the row to transform
      # @returns [Object] an object representing the fetched row
      def from_row(row)
        row
      end
    end
  end
end
