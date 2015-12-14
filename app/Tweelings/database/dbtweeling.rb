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
        :id,
        :id_twitter,
        :theme,
        :author,
        :text,
        :cleaned_text,
        :date,
        :criteria,
        :notation,
        :verified
      ]

      # Path to the SQL file to initialise database
      SQL_PATH = "data/sql/create_table.sql"

      ##
      # Initialises a new instance of the database object with the specific requests.
      ##
      def initialize
        super(TABLE, ID, FIELDS)

        REQUESTS[:fetch_uncleaned] = REQUESTS[:fetch] % "WHERE cleaned_text IS NULL %s"
        REQUESTS[:fetch_unverified] = REQUESTS[:fetch] % "WHERE verified = '0' %s"
        REQUESTS[:fetch_verified] = REQUESTS[:fetch] % "WHERE verified = '1' %s"
        REQUESTS[:update_annotation] = "UPDATE #{TABLE} SET notation = :notation, verified = :verified WHERE #{ID} = :id;"

        begin
          file = File.open(SQL_PATH, "rb")
          req = file.read

          db = SQLite3::Database.new(DB_PATH, DB_OPTIONS)
          db.execute_batch(req)
        rescue Errno::ENOENT
          # @todo Log the exception
          puts "[Error][DBTweeling::initialize] File %s does not exist" % SQL_PATH
        rescue SQLite3::SQLException => e
          # @todo Log the exception
          puts "[Error][DBTweeling::initialize] SQLException::Error code #{e.code}"
        ensure
          file.close if file
          db.close unless db.closed? if db
        end
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
            if arg
              stmt.execute(arg) do |results|
                results.each_hash { |row| res << from_row(row) }
              end
            else
              stmt.execute do |results|
                results.each_hash { |row| res << from_row(row) }
              end
            end
          end
        rescue SQLite3::SQLException => e
          # @todo Log the exception
          puts "[Error][DBTweeling::basic_fetch] SQLException::Error code #{e.code}"
          res = nil
        ensure
          db.close unless db.closed? if db
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
      # Fetches the unverified tweelings corresponding to the theme if specified.
      #
      # @param theme [String] the theme to fetch (optional)
      # @returns [Array<Object>, nil] an array containing the converted fetched object(s) using #from_row,
      #   or nil if the request failed
      ##
      def fetch_unverified(theme = nil)
        req = REQUESTS[:fetch_unverified] % (theme ? "AND theme = ?" : "")
        basic_fetch(req, theme)
      end

      ##
      # Fetches the verified tweelings corresponding to the theme if specified.
      #
      # @param theme [String] the theme to fetch (optional)
      # @returns [Array<Object>, nil] an array contaning the converted fetched object(s) using #from_row,
      #   or nil if the request failed
      ##
      def fetch_verified(theme = nil)
        req = REQUESTS[:fetch_verified] % (theme ? "AND theme = ?" : "")
        basis_fetch(req, theme)
      end

      ##
      # Converts the row into a [Tweelings::Object::Tweeling] instance.
      #
      # @param row [Hash] the row to transform
      # @returns [Tweelings::Object::Tweeling] the resulting object
      ##
      def from_row(row)
        Tweelings::Object::Tweeling.new(super(row))
      end

      ##
      # Update the annotation of the specified tweelings.
      #
      # @param *objects [Array<Tweelings::Object::Tweeling>] the tweelings to update
      # @returns [true, false] whether the request succeeded or not
      ##
      def update_annotation(*objects)
        req = REQUESTS[:update_annotation]

        params = objects.inject([]) do |acc, obj|
          hash = {
            id: obj.id,
            notation: obj.notation,
            verified: obj.verified
          }
          acc << hash
        end

        begin
          db = SQLite3::Database.new(DB_PATH, DB_OPTIONS)
          db.prepare(req) do |stmt|
            params.each do |object|
              begin
                stmt.execute(to_row(object))
              rescue SQLite3::ConstraintException => e
                puts "[Info][DBTweeling::update_annotation] Did not update tweet because of constraint #{e.code}"
              end
            end
          end
          true
        rescue SQLite3::SQLException => e
          # @todo Log the exception
          puts "[Error][DBTweeling::update_annotation] SQLException::Error code #{e.code}"
          false
        ensure
          db.close unless db.closed? if db
        end
      end

      ##
      # Retrieves all the rows.
      #
      # @param *indexes [Integer] the indexes of the row to fetch
      #   if empty, all rows will be fetched
      # @returns [Array<Object>, nil] an array of the rows converted to objects
      #   or nil if an exception occured.
      ##
      def fetch_id_twitter(*indexes)
        req = REQUESTS[:fetch] % "WHERE #{@id_twitter} IN(%s)" % Array.new(indexes.size, '?').join(', ')

        res = []
        begin
          db = SQLite3::Database.new(DB_PATH, DB_OPTIONS)
          db.prepare(req) do |stmt|
            stmt.execute(indexes) do |results|
              results.each_hash { |row| res << from_row(row) }
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

      private :basic_fetch
    end
  end
end