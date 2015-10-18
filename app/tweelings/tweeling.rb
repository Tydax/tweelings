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
    # Converts the specified array to a new tweeling object.
    def self.from_a(array)
        Tweeling.new(row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7])
    end

    ##
    # Converts the tweeling to an array. Used for CSV convertion.
    def to_a
        [@id, @id,@theme, @author, @text, @date, @criteria, @notation]        
    end

end