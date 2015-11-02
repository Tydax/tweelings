module Tweelings
    module Object
        ##
        # TwitterClient is the class used to interact with the Twitter library.
        #
        # @author Armand (Tydax) BOUR
        ##
        class TwitterClient

            ##
            # Intialises a twitter client with the YAML file at the specified path.
            #
            # @param [String] path the path to the config YAML file.
            ##
            def initialize(path)
                file = YAML.load_file(path)
                @client = Twitter::REST::Client.new do |config|
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
                tweets = @client.search(criteria.theme)
                
                # Take a certain number of tweets if indicated a limit
                criteria.number ? tweets.take(criteria.number) : tweets
            end
        end
    end
end