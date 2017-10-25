class Area < ApplicationRecord

    has_many :districts
    has_many :crowd_levels

end
