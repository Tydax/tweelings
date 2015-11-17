module Tweelings
  module Client
    ##
    # DummyTwitter is a class simulating a Twitter API request call using a file containing
    # the results and sending them instead of making an API call.
    #
    # @author Armand (Tydax) BOUR
    ##
    class DummyTwitter

      attr_reader :data

      ##
      # Initialises a new DummyTwitter client based on the file at the specified path.
      #
      # @param [String] path the path to the YAML file
      # @raises [Errno::ENOENT] if the file does not exist
      ##
      def initialize(path)
        @data = YAML.load_file(path)
      end

      def fetch_tweets(criteria)
        @data
      end
    end
  end
end