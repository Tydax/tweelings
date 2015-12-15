module Tweelings
  module Business
      ##
      # Class defining different algorithms used at the core of the application.
      #
      # @author Armand (Tydax) BOUR
      ##
    module Algorithm

      ##
      # Cleans the specified tweet text, removing all the Twitter-specific patterns.
      # Modifies the specified parameter.
      def self.clean_tweet!(text)
        text.downcase!
        text.gsub!(/rt @[^ ]* *: */, '') # Delete "RT @name"
        text.gsub!(/(@|https?:\/\/)[^ ]*/, '') # Delete the "@name"s
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
        buffer = text.dup
        clean_tweet!(buffer)
        buffer
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
      ##
      def self.annotate_using_keywords(text)
        splitted_text = text.split(' ')
        avg = (splitted_text - LEX_NEGATIVE).length - (splitted_text - LEX_POSITIVE).length

        case 
        when avg >  0 then Tweelings::Object::Tweeling::POSITIVE
        when avg == 0 then Tweelings::Object::Tweeling::NEUTRAL
        else               Tweelings::Object::Tweeling::NEGATIVE
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

      ##
      # Evaluates the specified tweet using the base.
      #
      # @param text [String] the text of the tweet to evaluate
      # @param base [Array<Tweeling::Object::Tweeling>] the base of text of tweets to use
      # @param neighbours [Integer] the number of neighbours to consider
      # @return [Integer] a number representing the annotation
      #   * 0 = negative
      #   * 2 = neutral
      #   * 4 = positive
      ##
      def self.annotate_using_knn(text, base, neighbours)
        # Take x neighbours
        close_neighbours = base.take(neighbours)

        # Browse through all neighbours
        base.last(base.length - neighbours).each do |i|
          dist_i = knn_dist_between(i.text, text)
          # Check if the distance is lower than one of the tweets in the close_neighbours
          if close_neighbours.find { |n| dist_i < knn_dist_between(n.text, text) }
            # Delete the furthest away tweet from close neighbours
            
            # Look for the furthest away tweet
            furthest_tweet = nil
            furthest_dist = -1

            close_neighbours.each do |x|
              dist = knn_dist_between(text, x.text)
              if furthest_dist < dist
                furthest_dist = dist
                furthest_tweet = x
              end
            end

            # Replace the furthest away tweet with the new one
            close_neighbours.delete(furthest_tweet)
            close_neighbours.push(i)
          end
        end

        # Get the most occurring notation in the close neighbours 
        close_neighbours.each { |e|  e.notation }.group_by { |t| t }.values.max_by(&:size).first.notation
      end

      def self.annotate_using_bayes(tweelings, base)
        neg_base = base.select { |tweel| tweel.notation == Tweelings::Object::Tweeling::NEGATIVE }
        neu_base = base.select { |tweel| tweel.notation == Tweelings::Object::Tweeling::NEUTRAL }
        pos_base = base.select { |tweel| tweel.notation == Tweelings::Object::Tweeling::POSITIVE }

        neg_occ = get_word_occurrences(*neg_base)
        neu_occ = get_word_occurrences(*neu_base)
        pos_occ = get_word_occurrences(*pos_base)

        base_occ = get_word_occurrences(*base)

        tweelings.each do |tweeling|
          prob = {}
          prob[Tweelings::Object::Tweeling::NEGATIVE] = predict_text_notation(tweeling.text, neg_occ, base_occ)
          prob[Tweelings::Object::Tweeling::NEUTRAL] = predict_text_notation(tweeling.text, neu_occ, base_occ)
          prob[Tweelings::Object::Tweeling::POSITIVE] = predict_text_notation(tweeling.text, pos_occ, base_occ)
        
          tweeling.notation = prob.max_by { |k, v| v }.first
        end
      end

      def self.get_word_occurrences(*tweelings)
        texts = tweelings.map { |tweeling|  tweeling.text.split(' ')}
        texts.inject(Hash.new(0)) do |mainhash, text|
          onehash = text.inject(Hash.new(0)) do |hash, word|
            hash[word] += 1
            hash
          end

          mainhash.merge(onehash) { |_, val1, val2| val1 + val2 }
        end
      end

      ##
      # Predicts the probability of a word to belong to a notation
      #   using the specified occurrences.
      #
      # @param word [String] the word to use to predict
      # @param pol_occ [Hash<String, Integer>] the occurences of words in a text of the wanted notation
      # @param base_occ [Hash<String, Integer>] the occurences of words in every text of the base
      # @return [Double] the probability
      ##
      def self.predict_word_notation(word, pol_occ, base_occ)
        # n(m, c) + 1
        nmc = pol_occ[word] + 1.0
        # N
        n = base_occ.inject(0.0) { |acc, (k, v)| acc + v }
        # n(c)+ N
        ncn = pol_occ.inject(n) { |acc, (k, v)| acc + v }
        # (n(m, c) + 1) / (n(c) + N)
        nmc / ncn
      end

      ##
      # Predicts the probability of a text to belong to a notation
      #   using the specified occurrence.
      #
      # @param text [String] the text to use to predict
      # @param pol_occ [Hash<String, Integer>] the occurences of words in a text of the wanted notation
      # @param base_occ [Hash<String, Integer>] the occurences of words in every text of the base
      # @return [Double] the probability
      def self.predict_text_notation(text, pol_occ, base_occ)
        text.split(' ').inject(1.0) { |proba, word| proba * predict_word_notation(word, pol_occ, base_occ) }
      end
    end
  end
end
