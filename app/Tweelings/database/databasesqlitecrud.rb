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
      # @param tablename [Symbol] the name of the table
      # @param id [Symbol] the name of the field representing the id
      # @param fields [Array<Symbol>] the Array containing the field name in Symbol 
      ##
      def initialize(tablename, id, fields)
        @table = tablename
        @id = id
        @fields = fields
        @fields_joined = @fields.join(', ').intern
        keys = @fields.map { |k| ":" << k.to_s}

        ## Requests
        REQUESTS[:fetch]  = "SELECT #{@fields_joined} FROM #{@table} %s;"
        REQUESTS[:save]   = "INSERT INTO #{@table} (#{@fields_joined}) VALUES (#{keys.join(', ')});"
        REQUESTS[:delete] = "DELETE FROM #{@table} WHERE #{@id} IN(%s);"
        
        # Creating a "id = :id" formated string
        f = []
        @fields.zip(Array.new(@fields.size, ' = '), keys) { |e| f << e.join }
        REQUESTS[:update] = "UPDATE #{@table} SET #{f.join(', ')} WHERE #{@id} = #{':' << @id.to_s};"
      end

      ##
      # Retrieves all the rows.
      #
      # @param *indexes [Integer] the indexes of the row to fetch
      #   if empty, all rows will be fetched
      # @returns [Array<Object>, nil] an array of the rows converted to objects
      #   or nil if an exception occured.
      ##
      def fetch(*indexes)
        if indexes.empty?
          req = REQUESTS[:fetch] % ""
        else
          req = REQUESTS[:fetch] % "WHERE #{@id} IN(%s)" % Array.new(indexes.size, '?').join(', ')
        end

        res = []
        begin
          db = SQLite3::Database.new(DB_PATH, DB_OPTIONS)
          db.prepare(req) do |stmt|
            if indexes.empty?
              stmt.execute do |results|
                results.each_hash { |row| res << from_row(row) }
              end
            else
              stmt.execute(indexes) do |results|
                results.each_hash { |row| res << from_row(row) }
              end
            end
          end
        rescue SQLite3::SQLException => e
          # @todo Log the exception
          puts "[Error][DatabaseSQLiteCRUD::fetch] SQLException::Error code #{e.code}"
          res = nil
        ensure
          db.close unless db.closed? if db
        end

        res
      end

      ##
      # Inserts a new row.
      #
      # @param [Array<#id>] object the object to be inserted
      # @returns [true, false] whether the request succeeded or not
      ##
      def save(*objects)
        res = 0;
        req = REQUESTS[:save]
        begin
          db = SQLite3::Database.new(DB_PATH, DB_OPTIONS)
          db.prepare(req) do |stmt|
            objects.each do |obj|
              begin
                stmt.execute(to_row(obj))
                obj.id = db.last_insert_row_id
                res += 1
              rescue SQLite3::ConstraintException => e
                puts "[Info][DatabaseSQLiteCRUD::save] Not inserting already existing tweeling"
              end
            end
          end
        rescue SQLite3::SQLException => e
          # @todo Log the exception
          puts "[Error][DatabaseSQLiteCRUD::save] SQLException::Error code #{e.code}"
          res = -1
        ensure
          db.close unless db.closed? if db
        end
        res
      end

      ##
      # Deletes the rows with the specified indexes.
      #
      # @param [Array<Integer>] index the index(es) of the rows to delete
      # @returns [true, false] whether the request succeeded or not
      ##
      def delete(*indexes)
        req = REQUESTS[:delete] % Array.new(indexes.size, '?').join(', ')
        
        begin
          db = SQLite3::Database.new(DB_PATH, DB_OPTIONS)
          db.prepare(req) { |stmt| stmt.execute(indexes) }
          true
        rescue SQLite3::SQLException => e
          # @todo Log the exception
          puts "[Error][DatabaseSQLiteCRUD::delete] SQLException::Error code #{e.code}"
          false          
        ensure
          db.close unless db.closed? if db
        end
      end

      ##
      # Updates the rows corresponding to the specified object.
      # @param objects* [Object] the object to update
      # @returns [true, false] whether the request succeeded or not
      ##
      def update(*objects)
        req = REQUESTS[:update]

        begin
          db = SQLite3::Database.new(DB_PATH, DB_OPTIONS)
          db.prepare(req) do |stmt|
            objects.each do |object|
              begin
                stmt.execute(to_row(object))
              rescue SQLite3::ConstraintException => e
                puts "[Info][DatabaseSQLiteCRUD::update] Did not update tweet because of constraint"
              end
            end
          end
          true
        rescue SQLite3::SQLException => e
          # @todo Log the exception
          puts "[Error][DatabaseSQLiteCRUD::update] SQLException::Error code #{e.code}"
          false
        ensure
          db.close unless db.closed? if db
        end
      end

      ##
      # Default implementation of the method used to transform an object into a hash.
      # Called by #save and #update.
      #
      # @param object [#to_h] the object to transform
      # @returns [Hash<Symbol, Object>] a hash containing the column name as keys and the attributes of the object as values.
      ##
      def to_row(object)
        hash = object.to_h
        hash.each do |k, v|
          case v
          when TrueClass then hash[k] = 1
          when FalseClass then hash[k] = 0
          end
        end
        hash
      end

      ##
      # Default implementation of the method used to transform a row into an object.
      # Called by #fetch.
      #
      # @param row [Hash] the row to transform
      # @returns [Hash] the row
      ##
      def from_row(row)
        row.each_with_object({}) { |(k, v), h| h[k.to_sym] = v}
      end
    end
  end
end
