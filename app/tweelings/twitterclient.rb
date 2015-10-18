# Base libraries
require 'yaml'

# Downloaded libraries
require 'twitter'

# My libraries
require 'tweelings/utils'

##
# TwitterClient is the class used to interact with the Twitter library.
#
# Author:: Armand (Tydax) BOUR
class TwitterClient

    ##
    # Constructor intialising a twitter client with the file at the specified path.
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
    def fetch_tweets(criteria)
        tweets = @client.search(Utils.request_from_criteria(criteria))
        
        # Take a certain number of tweets if indicated a limit
        criteria[:number] ? tweets.take(criteria[:number]) : tweets
    end
end