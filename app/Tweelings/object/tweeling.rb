module Tweelings
  module Object
    ##
    # Class defining an annoted tweet object.
    # @todo document the class
    # @author Armand (Tydax) BOUR
    class Tweeling
      attr_accessor :id,
                    :id_twitter,
                    :theme,
                    :author,
                    :text,
                    :date,
                    :criteria,
                    :notation 


      def initialize(id, id_twitter, theme, author, text, date, criteria, notation)
        @id = id
        @id_twitter = id_twitter
        @theme = theme
        @author = author
        @text = text
        @date = date
        @criteria = criteria
        @notation = notation
      end

      def self.from_raw(tweet, criteria)
        Tweeling.new(-1,
                    tweet.id,
                    criteria.theme,
                    tweet.user.screen_name,
                    tweet.text,
                    tweet.created_at,
                    criteria.to_req,
                    -1)
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
          @date,
          @criteria,
          @notation
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
          id:         @id,
          id_twitter: @id_twitter,
          theme:      @theme,
          author:     @author,
          text:       @text,
          date:       @date,
          criteria:   @criteria,
          notation:   @notation
        }
      end

      def to_h_for_json
        {
          "id"         => @id,
          "id_twitter" => @id_twitter,
          "theme"      => @theme,
          "author"     => @author,
          "text"       => @text,
          "date"       => @date,
          "criteria"   => @criteria,
          "notation"   => @notation
        }
      end
    end
  end
end
