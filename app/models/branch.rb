class Branch < ApplicationRecord

  belongs_to :business
  has_many :crowd_levels

  validates :name, presence: true
  validates :address, presence: true

end
