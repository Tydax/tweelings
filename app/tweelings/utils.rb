# Base libraries
require 'csv'

# Downloaded libraries
require 'twitter'

##
# Utils offers functions used to all kind of utility purpose.
#
# Author:: Armand (Tydax) BOUR
class Utils
    # TODO: delete this useless method...
    def self.theme_from_criteria(criteria)
        theme = "#{criteria[:theme]}"
    end


    def self.tweelings_to_a(array)
        result = []
        array.each do |tweeling|
            result.push(tweeling.to_a)
        end
        result
    end
end