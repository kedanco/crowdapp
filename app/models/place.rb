class Place < ApplicationRecord

  has_many :crowd_levels, dependent: :destroy
  belongs_to :district

  validates :name, presence: true
  validates :address, presence: true


  def most_crowded

    most_crowded_levels = []
    most_crowded_info = []


    densities = self.crowd_levels.pluck(:crowd_density)

    self.crowd_levels.map{|level| most_crowded_levels << level if level.crowd_density == densities.max}

    if !most_crowded_levels.blank?

      most_crowded_levels.each do |crowd_level|

        info = {:day=>crowd_level.day,:hour=>crowd_level.hour,:crowd_density=>crowd_level.crowd_density}

        most_crowded_info << info
        
      end

    end

    most_crowded_info

  end

  def least_crowded

    least_crowded_levels = []
    least_crowded_info = []

    densities = self.crowd_levels.pluck(:crowd_density).reject{|r| r == 0}

    self.crowd_levels.map{|level| least_crowded_levels << level if level.crowd_density == densities.min}

    if !least_crowded_levels.blank?

      least_crowded_levels.each do |crowd_level|

        info = {:day=>crowd_level.day,:hour=>crowd_level.hour,:crowd_density=>crowd_level.crowd_density}

        least_crowded_info << info

      end

    end

    least_crowded_info

  end


end
