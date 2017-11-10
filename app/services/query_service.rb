class QueryService

  def self.hour_24_to_12(hour_24)
    hour_12 = hour_24 - 12

    if hour_12 == 0
      return "12PM"

    elsif hour_12 == -12
      return "12AM"

    elsif hour_12 > 0
      return "#{hour_12}PM"

    elsif hour_12 < 0
      return "#{hour_24}AM"

    else
      # The passed-in time is outside the range o 0-23,
      # so you may need to deal with this however you
      # feel is appropriate
    end

  end


end
