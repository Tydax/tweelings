module Tweelings
  module Object
    ##
    # Class encapsulating the criteria used to fetch tweets.
    #
    # @author Armand (Tydax) BOUR
    ##
    class Criteria
      attr_accessor :theme,
                    :number

      ##
      # Initialises a new criteria object.
      #
      # @param [String] theme the words to look for
      # @param [Integer] number the number of tweets to fetch (-1 to fetch all)
      ##
      def initialize(theme, number = nil)
        @theme = theme
        @number = number
      end

      def to_req
        "#{@theme}"
      end
    end
  end
end