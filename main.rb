lib = File.expand_path("../app", __FILE__)
  $:.unshift(lib)
# Downloaded libraries
require 'sinatra'

# My libraries
require 'tweelings/ajaxview'

get '/' do
    File.read(File.join('public', 'html/index.html'))
end

post '/fetch_tweets' do
    content_type :json
    # puts "Request body: #{request.body.read}"
    if request.post?
        parsedParams = JSON.parse(request.body.read)
        AjaxView.fetch_tweets(parsedParams)
    else
        "Hey, what did you, 'spect?"
        # TODO: redirect to an error page
    end
end

get '/save_tweets' do
    if request.xhr?
        AjaxView.save_tweets    
    end
end
