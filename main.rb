lib = File.expand_path("../app", __FILE__)
  $:.unshift(lib)
# Downloaded libraries
require 'sinatra'

# My libraries
require 'tweelings'

get '/' do
    client = TwitterClient.new('config/app_config.yaml')
    criteria = {
        word: 'PreenceArmand',
        number: 10 }
    tweets = client.fetch_tweets(criteria)
    Utils.convert_to_csv(tweets, criteria)
    return "It worked!! Yay!!"
end
