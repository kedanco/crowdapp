class Place < ApplicationRecord

  has_many :crowd_levels, dependent: :destroy
  belongs_to :district

  validates :name, presence: true
  validates :address, presence: true


end
