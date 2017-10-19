class Place < ApplicationRecord

  has_many :crowd_levels, dependent: :destroy

  validates :name, presence: true
  validates :address, presence: true


end
