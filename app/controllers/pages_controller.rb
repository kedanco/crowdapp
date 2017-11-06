class PagesController < ApplicationController

  def index
  end

  def settings
  end

  def faq
  end

  def home
    # @areas = Area.all
    @areas = Area.where.not(name: "east")

    @districts = District.all
    # @district_names = ImportService.initDistrict
    # @district_names = District.select(:name)
    
  end

  def output_to_map
    @areas = Area.where.not(name: "east")

    @districts = District.all

    search_value = params[:search_result]
    area_value = params[:area_checkbox]
    crowdlevel_value = params[:crowdlevel]
    datetime_value = params[:date_time]

    crowd_filtered_places = []

    # Get search results

    if search_value != ""
      @search_places = Place.where("name ilike ?", "%#{search_value}%")
      if @search_places == []
        # display msgbox when query database not found
      
      end
    else
        # display msgbox when click blank in search
  
    end

    search_places = search_places.to_a

    # Implement filters on search_places

    # Area filter
    if area_value != nil

      search_places.delete_if{|place| !area_value.include?(place.district.area_id)}

    end

    # # Date & Time Filter
    # if datetime_value == ""

    #   datetime_value = DateTime.now

    # end

    #   search_places.delete_if{ |place|

    #     hour = datetime_value.strftime("%H")
    #     day = datetime_value.strftime("%A")

    #     cl = place.crowd_levels
    #     cl.each do |crowd_level|

    #        (crowd_level.hour != hour) || (crowd_level.day != day)

    #     end

    #   }

    

    # Crowded/Not Crowded Filter
    if crowdlevel_value != nil

      search_places.delete_if{|place|

        cl = place.crowd_levels
        average_density = (cl.sum(:crowd_density)/cl.count)

          if crowdlevel_value == crowded

            crowd_level.crowd_density < 75

          elsif crowdlevel_value == not_crowded

            crowd_level.crowd_density > 25

          end
      }

    end  

    respond_to do |format|
      format.js   
    end

    # output_to_map.js.erb
  end

end
