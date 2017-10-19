class CrowdLevel < ApplicationRecord

  belongs_to :place
  validates :hour, presence: true
  validates :day, presence: true
  validates :density, presence: true

end
