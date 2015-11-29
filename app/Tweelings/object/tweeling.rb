module Tweelings
  module Object
    ##
    # Class defining an annoted tweet object.
    # @todo document the class
    # @author Armand (Tydax) BOUR
    class Tweeling

      attr_reader :id_twitter,
                  :theme,
                  :author,
                  :text,
                  :date,
                  :criteria

      attr_accessor :id,
                    :cleaned_text,
                    :notation,
                    :verified

      ##
      # Initialises a new tweeling using the specified parameters.
      #
      # @param params [Hash<Symbol, Object>] the parameters used to initialise the object, the key
      #   being the Symbol with the same name as the attribute.
      ##
      def initialize(params)
        @id = params[:id]
        @id_twitter = params[:id_twitter]
        @theme = params[:theme]
        @author = params[:author]
        @text = params[:text]
        @cleaned_text = params[:cleaned_text]
        @date = params[:date]
        @criteria = params[:criteria]
        @notation = params[:notation]
        @verified = params[:verified]
      end

      ##
      # Initialises a new tweeling object from a raw tweet.
      # The #id and #cleaned_text attributes are set to nil.
      ##
      def self.from_raw(tweet, criteria)
        Tweeling.new(
          id_twitter:   tweet.id,
          theme:        criteria.theme,
          author:       tweet.user.screen_name,
          text:         tweet.text,
          date:         tweet.created_at,
          criteria:     criteria.to_req,
          verified:     false
        )
      end

      ##
      # Converts the tweeling to a simple array.
      #
      # @returns [Array<Object>]
      ##
      def to_a
        [
          @id,
          @id_twitter,
          @theme,
          @author,
          @text,
          @cleaned_text,
          @date,
          @criteria,
          @notation,
          @verified
        ]        
      end

      ##
      # Converts the tweeling to a hash.
      #
      # @returns [Hash<Symbol, Object>] representing the object, the attributes' names as keys
      #   and the attributes' values as values
      ##
      def to_h
        {
          id:           @id,
          id_twitter:   @id_twitter,
          theme:        @theme,
          author:       @author,
          text:         @text,
          cleaned_text: @cleaned_text,
          date:         @date,
          criteria:     @criteria,
          notation:     @notation,
          verified:     @verified
        }
      end
    end
  end
end
