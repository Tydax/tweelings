require 'sinatra'

get '/' do
    redirect to('/hello/world')
end

get '/hello/:name' do
    "Hello #{params[:name]}"
end