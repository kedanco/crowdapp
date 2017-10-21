class CrowdLevel < ApplicationRecord

  belongs_to :place
  validates :hour, presence: true
  validates :day, presence: true
  validates :crowd_density, presence: true

end
