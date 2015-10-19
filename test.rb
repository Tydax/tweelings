lib = File.expand_path("../app", __FILE__)
  $:.unshift(lib)

require 'tweelings'

text = "RT @Ingrid: @MadameZahia  Woo La fange  madame zahia !!   ! j'adore la #fange c'est assez incroyable boué de sauvetage    le caca est ma passion."
res = Algorithm.clean_tweet(text)
puts res
res = Algorithm.annotate_using_keywords(res)
puts res