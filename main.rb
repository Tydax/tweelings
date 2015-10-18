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
    AjaxView.fetch_tweets(request.POST.inspect)
end

post '/save_tweets' do
    AjaxView.save_tweets    
end
