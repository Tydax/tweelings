
# Downloaded libraries
require 'json'

# My libraries
require 'tweelings/core'
require 'tweelings/utils'

##
# Class used to interact between the core application and the interface.
module AjaxView

    CODE_SUCESS = 0
    CODE_NO_PARAMS = -1

    def self.fetch_tweets(params)
        # TODO: use an object for criteria...

        # Check for params
        if params == nil || param == ""
            return JSON.parse(["code" => CODE_NO_PARAMS])
        end

        params = JSON.parse(params)
        criteria = {
            theme: params["theme"],
            number: params["number"]
        }
        result = Core.fetch_tweets(criteria).length
        JSON.parse(["code" => CODE_SUCCESS, "result" => "#{result}"])
    end
    
    def self.save_tweets
        result = Core.convert_tweets
        JSON.parse(Utils.tweelings_to_a(result))
    end
end