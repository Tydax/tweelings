module Tweelings
  module View
    ##
    # Class used to interact between the core application and the interface.
    #
    # @author: Armand (Tydax) BOUR
    ##
    module AjaxView

      CODE_SUCCESS = 0
      CODE_NO_PARAMS = -1
      CODE_RATE_LIMIT = -2

      MSG_GENERATOR = Tweelings::Utils::ENMessageGenerator

      def self.fetch_tweets(params)
        # Check for params
        if params == nil || params == "{}"
            return JSON.generate(:code => CODE_NO_PARAMS)
        end

        criteria = Tweelings::Object::Criteria.new(params["theme"], params["number"])
        
        begin
          result = Tweelings::TweelingsCore::Core.fetch_tweets(criteria)
          puts "[AjaxView] fetch_tweets:: Response sent"
          res = {
            :code => CODE_SUCCESS,
            :result => result
          }
        rescue Twitter::Error::TooManyRequests => error
          res = {
            :code => CODE_RATE_LIMIT,
            :result => "#{MSG_GENERATOR::ERR_RATE_LIMIT_EXCEEDED % error.rate_limit.reset_in}"
          }
        end

        JSON.generate(res)
      end

      def self.clean_tweets
        result = Tweelings::TweelingsCore::Core.clean_tweets
        # binding.pry
        puts "[AjaxView] clean_tweets:: Response sent"
        res = {
              :code => CODE_SUCCESS,
              :result => result
            }

        JSON.generate(res)
      end

      def self.annotate_tweets(params)
        # Check for params
        if params == nil || params == "{}"
            return JSON.generate(:code => CODE_NO_PARAMS)
        end

        result = Tweelings::TweelingsCore::Core.annotate_tweets(params["algorithm"], params["nb_neighbours"])
        result.map! { |tweeling| JSON.generate(tweeling.to_h_for_json) }
        puts "[AjaxView] anotate_tweets:: Response sent"
        res = {
              :code => CODE_SUCCESS,
              :result => result
            }

        JSON.generate(res)
      end

      def self.update_tweets(params)
        if !params || params == "{}"
          return JSON.generate(:code => CODE_NO_PARAMS)
        end

        tweelings = params["tweets"].each_with_object([]) do |param, arr|
          arr << param.inject({}) { |memo, (k, v)| memo[k.to_sym] = v; memo }
        end

        result = Tweelings::TweelingsCore::Core.update_tweets(tweelings)

        res = {
          :code => CODE_SUCCESS,
          :result => result
        }

        JSON.generate(res)
      end
    end
  end
end
