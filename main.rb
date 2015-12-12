lib = File.expand_path("../app", __FILE__)
  $:.unshift(lib)
# Downloaded libraries
# For debugging
require 'better_errors'
require 'binding_of_caller'
require 'pry'

require 'sinatra'

# My libraries
require 'tweelings'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end

get '/' do
  File.read(File.join('public', 'html/index.html'))
end

post '/fetch_tweets' do
  content_type :json
  if request.post?
    parsedParams = JSON.parse(request.body.read)
    Tweelings::View::AjaxView.fetch_tweets(parsedParams)
  else
    "Hey, what did you, 'spect?"
    # TODO: redirect to an error page
  end
end

# get '/save_tweets' do
#   if request.get?
#     Tweelings::View::AjaxView.save_tweets  
#   else
#     "Hey, what did you, 'spect"
#     # TODO: redirect to an error page
#   end
# end

get '/clean_tweets' do
  if request.get?
    Tweelings::View::AjaxView.clean_tweets  
  else
    "Hey, what did you, 'spect"
    # TODO: redirect to an error page
  end
end

post '/annotate_tweets' do
  content_type :json
  if request.post?
    parsedParams = JSON.parse(request.body.read)
    Tweelings::View::AjaxView.annotate_tweets(parsedParams)
  else
    "Hey, what did you, 'spect"
    # TODO: redirect to an error page
  end
end

post '/anotate_tweets_manually' do
  content_type :json
  if request.post?
    parsedParams = JSON.parse(request.body.read)
    Tweelings::View::AjaxView.anotate_tweets_manually(parsedParams)
  else
    "Hey, what did you, 'spect"
    # TODO: redirect to an error page
  end
end
