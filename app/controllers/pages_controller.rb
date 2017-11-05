class PagesController < ApplicationController

  def index
  end

  def settings
  end

  def faq
  end

  def home
    @areas = Area.all

    @districts = District.all
    # @district_names = ImportService.initDistrict
    # @district_names = District.select(:name)
    
  end

  def output_to_map
    @districts = District.all

    search_value = params[:search_result]
    area_value = params[:area_checkbox]
    crowdlevel_value = params[:crowdlevel]
    datetime_value = params[:date_time]

    crowd_filtered_places = []

    # Get search results

    search_places = Place.where("name LIKE %search_value%")

    # Implement filters on search_places

    # Area filter
    if area_value != nil

      search_places.delete_if{|place| !area_value.include?(place.district.area_id)}

    end

    # Date & Time Filter
    if datetime_value != nil

      search_places.delete_if{ |place|

        hour = datetime_value.strftime("%H")
        day = datetime_value.strftime("%A")

        place.each do |crowd_level|

           (crowd_level.hour != hour) || (crowd_level.day != day)

        end

      }

    end

    # Crowded/Not Crowded Filter
    if crowdlevel_value != nil

      search_places.delete_if{|place|

        cl = place.crowd_levels
        average_density = (cl.sum(:crowd_density)/cl.count)

          if crowdlevel_value == crowded

            crowd_level.crowd_density > 75

          elsif crowdlevel_value == not_crowded

            crowd_level.crowd_density < 25

          end

        end

      }

    end

    @areas = Area.where(name: area_value)  
    # render "pages/home"  

    respond_to do |format|
      format.js   
    end

    # output_to_map.js.erb
  end

end
