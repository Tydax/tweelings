lib = File.expand_path("../app", __FILE__)
  $:.unshift(lib)
require 'tweelings/tweeling'
require 'tweelings/utils'

tweeling = Tweeling.new(0, 12345, "fange", "MadameZahia", "Quelles délices fangeux !!!", "21/10/2015", "fange", -1);
array = [tweeling, Tweeling.new(1, 1236, "fange", "Ingrid", "ah ben jsen que sa va etr cho ce soar!!", "10/10/2015", "fange", -1)]

puts Utils.tweelings_to_json(array)