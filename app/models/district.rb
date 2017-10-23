class District < ApplicationRecord

    has_many :places
    has_many :crowd_levels, through: :places
    belongs_to :area

end
