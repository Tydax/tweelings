
require 'tweelings/utils'

##
# Class defining an annoted tweet object.
#
# Author:: Armand (Tydax) BOUR
class Tweeling
    attr_accessor: :id,
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

    ##
    # Converts the tweeling to an array. Used for CSV convertion.
    def to_a
        [@id, @id,@theme, @author, @text, @date, @criteria, @notation]        
    end

    def self.from_raw(tweet, criteria)
        Tweeling.new(-1,
                    tweet.id,
                    Utils.theme_from_criteria(criteria),
                    tweet.user.screen_name,
                    tweet.text,
                    tweet.created_at,
                    criteria,
                    -1)
end