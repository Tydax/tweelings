lib = File.expand_path("../app", __FILE__)
  $:.unshift(lib)
# Downloaded libraries
require 'sinatra'

# My libraries
require 'tweelings'

get '/' do
    File.read(File.join('public', 'html/index.html'))
end
