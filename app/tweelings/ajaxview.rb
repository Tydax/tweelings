
# Downloaded libraries
require 'json'

# My libraries
require 'tweelings/criteria'
require 'tweelings/core'
require 'tweelings/utils'

##
# Class used to interact between the core application and the interface.
module AjaxView

    CODE_SUCCESS = 0
    CODE_NO_PARAMS = -1

    def self.fetch_tweets(params)
        # Check for params
        if params == nil || params == "{}"
            return JSON.generate({:code => CODE_NO_PARAMS})
        end

        criteria = Criteria.new(params["theme"], params["number"])
        result = Core.fetch_tweets(criteria)
        puts "[AjaxView] fetch_tweets:: Response sent"
        JSON.generate(:code => CODE_SUCCESS,
                      :result => "#{result.count}")
    end
    
    def self.save_tweets
        result = Core.convert_tweets
        JSON.generate(:code => CODE_SUCCESS,
                      :result => "#{Utils.tweelings_to_a(result)}")
    end
end