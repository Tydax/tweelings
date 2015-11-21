module Tweelings
  module Client
    ##
    # TwitterREST is the class used to interact with the Twitter library
    # using the REST API.
    #
    # @author Armand (Tydax) BOUR
    ##
    class TwitterREST

      ##
      # Initialises a new Twitter REST client with the YAML file at the specified path.
      #
      # @param [String] path the path to the config YAML file
      # @raise [Errno::ENOENT] if the file does not exist
      # @raise [ArgumentError] if the file contains incomplete configuration
      ##
      def initialize(path)
        file = YAML.load_file(path)
        proxy = file[:proxy]

        # Raise exception if missing any information
        arg =
          case
          when !file[:consumer_key]         then 'consumer_key'
          when !file[:consumer_secret]      then 'consumer_secret'
          when !file[:access_token]         then 'access_token'
          when !file[:access_token_secret]  then 'access_token_secret'
          when proxy
            case
            when !proxy[:host]  then 'proxy'
            when !proxy[:port]  then 'port'
            when proxy[:password] && !proxy[:username] then 'username'
            when proxy[:username] && !proxy[:password] then 'password'
            end
          else nil
          end

        raise ArgumentError.new("Incomplete Twitter app configuration file (missing %s)" % arg) if arg

        @client = Twitter::REST::Client.new do |config|
            config.consumer_key         = file[:consumer_key]
            config.consumer_secret      = file[:consumer_secret]
            config.access_token         = file[:access_token]
            config.access_token_secret  = file[:access_token_secret]
            config.proxy                = proxy
        end
      end

      ##
      # Fetches all tweets with the specified criteria.
      #
      # @param [Criteria] criteria the criteria used to searched for tweets
      # @returns [Array<>] the list of tweets fetched
      # @raises [Twitter::Error::TooManyRequests] if the maximum number of requests is reached
      ##
      def fetch_tweets(criteria)
        begin
          tweets = @client.search(criteria.to_req)
        rescue Twitter::Error::TooManyRequests => error
          raise error
        end

        # Take a certain number of tweets if indicated a limit
        criteria.number ? tweets.take(criteria.number).to_a : tweets.to_a
      end

      ##
      # Fetches all tweets with the specified criteria and write them to the file at the
      # specified path.
      #
      # @param [Criteria] criteria the criteria used to searched for tweets
      # @param [String] path the path to the file
      # @raises [Twitter::Error::TooManyRequests] if the maximum number of requests is reached
      ##
      def write_tweets_to_file(criteria, path)
        res = fetch_tweets(criteria)

        file = File.open(path, "w")
        YAML.dump(res, file)
        file.close
      end
    end
  end
end
