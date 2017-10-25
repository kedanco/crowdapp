class District < ApplicationRecord

    has_many :places
    has_many :crowd_levels
    belongs_to :area

end
