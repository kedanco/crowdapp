class CrowdLevel < ApplicationRecord

  belongs_to :place, optional: true
  belongs_to :district, optional: true
  belongs_to :area, optional: true
  
  validates :hour, presence: true
  validates :day, presence: true
  validates :crowd_density, presence: true

end
