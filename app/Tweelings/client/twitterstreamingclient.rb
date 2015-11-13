module Tweelings
  module Client
    ##
    # TwitterStreamingClient is the class used to interact with the Twitter library
    # using the Streaming API.
    #
    # @author Armand (Tydax) BOUR
    ##
    class TwitterStreamingClient
      
      ##
      # Intialises a twitter client with the YAML file at the specified path.
      #
      # @param [String] path the path to the config YAML file.
      ##
      def initialize(path)
        file = YAML.load_file(path)
        @client = Twitter::Streaming::Client.new do |config|
            config.consumer_key         = file[:consumer_key]
            config.consumer_secret      = file[:consumer_secret]
            config.access_token         = file[:access_token]
            config.access_token_secret  = file[:access_token_secret]
        end
      end

      ##
      # Fetches all tweets with the specified criteria.
      #
      # @param
      def fetch_tweets(criteria)
        @client.filter(track: criteria.theme) do |object|
          puts object.text if object.is_a?(Twitter::Tweet)
        end
      end
    end
  end
end