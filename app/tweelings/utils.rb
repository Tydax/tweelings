# Base libraries
require 'csv'

# Downloaded libraries
require 'twitter'

##
# Utils offers functions used to all kind of utility purpose.
#
# Author:: Armand (Tydax) BOUR
class Utils
    def self.request_from_criteria(criteria)
        res = "#{criteria[:word]}"
        return res
    end
end