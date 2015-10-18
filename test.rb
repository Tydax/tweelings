lib = File.expand_path("../app", __FILE__)
  $:.unshift(lib)
require 'tweelings'

string = "RT @PreenceArmand : @DaryKiley je suis une pute à merde. poke @MadameZahia j'adore le chocolat!! http://www.fange.fr Malgré mon homosexualité. #fange #puteàmerde"
Algorithm.clean_tweet!(string)
puts string