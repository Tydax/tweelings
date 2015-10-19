##
# Class defining different algorithms used at the core of the application.
#
# @author Armand (Tydax) BOUR
module Algorithm

    ##
    # Cleans the specified tweet text, removing all the Twitter-specific patterns.
    # Modifies the specified parameter.
    def self.clean_tweet!(text)
        text.downcase!
        text.gsub!(/rt @[^ ]* *: */, '') # Delete "RT @name"
        text.gsub!(/(@|http:\/\/)[^ ]*/, '') # Delete the "@name"s
        text.gsub!(/(?=[[:punct:]“”’…])/, ' \1 ') # Space behind and after each punctation symbol
        text.gsub!(/\'/, ' \' ') # Space behind and after each simple quote (I don't know why but I have to do it manually
        text.gsub!(/ {2,}/, ' ') # Delete double spaces
        text.gsub!(/#(?=[^ ]*)/, '\1') # Delete hash from hastags
        text.strip!
    end

    ##
    # Cleans the specified tweet text, removing all the Twitter-specific patterns.
    # Returns the specified parameter.
    def self.clean_tweet(text)
        text = text.downcase
        text = text.gsub(/RT @[^ ]* *: */, '') # Delete "RT @name"
        text = text.gsub(/(@|http:\/\/)[^ ]*/, '') # Delete the "@name"s
        text = text.gsub(/(?=[[:punct:]“”’…])/, ' \1 ') # Space behind and after each punctation symbol
        text = text.gsub(/\'/, ' \' ') # Space behind and after each simple quote (I don't know why but I have to do it manually
        text = text.gsub(/ {2,}/, ' ') # Delete double spaces
        text = text.gsub(/#(?=[^ ]*)/, '\1') # Delete hash from hastags
        text = text.strip
    end

    # The positive word lexicon.
    LEX_POSITIVE = File.read("data/lex_positive.txt").downcase.split(",").map(&:strip)
    # The negative word lexicon.
    LEX_NEGATIVE = File.read("data/lex_negative.txt").downcase.split(",").map(&:strip)

    ##
    # Evaluates the specified tweet text.
    #
    # @param [String] text the text to evaluate
    # @return [Integer] a number representing the annotation
    #   * 0 = negative
    #   * 2 = neutral
    #   * 4 = positive
    ##
    def self.annotate_using_keywords(text)
        res = 0

        LEX_POSITIVE.each do |word|
            if text.include?(word)
                puts "#{word}++"
                res += 1
            end
        end

        LEX_NEGATIVE.each do |word|
            if text.include?(word)
                puts "#{word}--"
                res -= 1
            end
        end

        if res > 0 # Positive
            4
        elsif res == 0 # Neutral
            2
        else # Negative
            0
        end
    end

    ##
    # Computes the distance between two texts by searching for common words.
    #
    # @param text1 [String] the first text to use
    # @param text2 [String] the second text to use
    # @returns [Float] a number between 0.0 and 1.0 representing the distance
    ##
    def self.knn_dist_between(text1, text2)
        text1 = text1.split(' ')
        text2 = text2.split(' ')
        common = (text1 & text2).length.to_f
        total = text1.length + text2.length

        (total - common) / total
    end
end