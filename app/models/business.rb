class Business < ApplicationRecord

  belongs_to :business_category
  has_many :branches

  validates :name, presence: true

end
