# Base libraries
require 'csv'

# Downloaded libraries
require 'twitter'

##
# Utils offers functions used to all kind of utility purpose.
#
# Author:: Armand (Tydax) BOUR
class Utils
    def self.theme_from_criteria(criteria)
        theme = "#{criteria[:word]}"
        theme
    end
end