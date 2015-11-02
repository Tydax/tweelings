module Tweelings
    module View
        ##
        # Class used to interact between the core application and the interface.
        #
        # @author: Armand (Tydax) BOUR
        ##
        module AjaxView

            CODE_SUCESS = 0
            CODE_NO_PARAMS = -1

            def self.fetch_tweets(params)
                # Check for params
                if params == nil || params == "{}"
                    return JSON.generate({:code => CODE_NO_PARAMS})
                end

                criteria = Tweelings::Object::Criteria.new(params["theme"], params["number"])
                result = Tweelings::Business::Core.fetch_tweets(criteria).count
                puts "Response sent"
                JSON.generate([:code => CODE_SUCCESS, :result => "#{result}"])
            end
            
            def self.save_tweets
                result = Tweelings::Business::Core.convert_tweets
                JSON.parse(Utils.tweelings_to_a(result))
            end
        end
    end
end