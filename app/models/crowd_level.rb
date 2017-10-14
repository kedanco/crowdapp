class CrowdLevel < ApplicationRecord

  belongs_to :branch
  validates :hour, presence: true
  validates :day, presence: true
  validates :density, presence: true

end
