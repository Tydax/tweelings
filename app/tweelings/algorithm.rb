##
# Class defining different algorithms used at the core of the application.
#
# Author:: Armand (Tydax) BOUR
class Algorithm

    ##
    # Cleans the specified tweet, removing all the Twitter-specific patterns.
    # Modifies the specified parameter.
    def self.clean_tweet!(tweet)
        tweet.gsub!(/RT @[^ ]* *: */, '') # Delete "RT @name"
        tweet.gsub!(/(@|http:\/\/)[^ ]*/, '') # Delete the "@name"s
        tweet.gsub!(/(?=[[:punct:]“”’…])/, ' \1 ') # Space behind and after each punctation symbol
        tweet.gsub!(/\'/, ' \' ') # Space behind and after each simple quote (I don't know why but I have to do it manually
        tweet.gsub!(/ {2,}/, ' ') # Delete double spaces
        tweet.gsub!(/#(?=[^ ]*)/, '\1') # Delete hash from hastags
    end

    ##
    # Cleans the specified tweet, removing all the Twitter-specific patterns.
    # Returns the specified parameter.
    def self.clean_tweet(tweet)
        tweet = tweet.gsub(/RT @[^ ]* *: */, '') # Delete "RT @name"
        tweet = tweet.gsub(/(@|http:\/\/)[^ ]*/, '') # Delete the "@name"s
        tweet = tweet.gsub(/(?=[[:punct:]“”’…])/, ' \1 ') # Space behind and after each punctation symbol
        tweet = tweet.gsub(/\'/, ' \' ') # Space behind and after each simple quote (I don't know why but I have to do it manually
        tweet = tweet.gsub(/ {2,}/, ' ') # Delete double spaces
        tweet = tweet.gsub(/#(?=[^ ]*)/, '\1') # Delete hash from hastags

        return tweet
    end
end