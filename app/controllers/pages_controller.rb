class PagesController < ApplicationController

  def index
  end

  def settings
  end

  def faq
  end

  def home
    @areas = Area.all
    # @areas = Area.where.not(name: "east")

    @districts = District.all
    # @district_names = ImportService.initDistrict
    # @district_names = District.select(:name)
  end

  def output_to_map
    # @areas = Area.where.not(name: "east")

    @districts = District.all

    search_value = params[:search_result]
    area_value = params[:area_checkbox]
    crowdlevel_value = params[:crowdlevel]&.first
    @datetime_value = params[:date_time]
    @crowdlevel_show

    crowd_filtered_places = []

    # Get search results

    if search_value != ""
      # have different queries and chain .where statements
      # combine different statements with && together
      @search_places = Place.where("name ilike ?", "%#{search_value}%")
      
      if @search_places == []
        # display flash when query database not found
        respond_to do |format|
          format.js { flash.now[:notice] = "Search does not exist" }
        end
      end
    else
        # display flash when search is blank       
        respond_to do |format|
          format.js { flash.now[:notice] = "Search cannot be blank" }
        end  
    end

    @search_places = @search_places.to_a

    # Implement filters on search_places

    # Area filter
    if area_value != nil

      @search_places.delete_if{|place|
        area_name = Area.find(place.district.area_id).name
        !(area_value.include?(area_name))
      }

    end

    #Date time filters 
    @datetime_value = DateTime.now if @datetime_value == ""
    @datetime_value = @datetime_value.to_datetime

    @hour = @datetime_value.strftime("%H")
    @day = @datetime_value.strftime("%A")

    # Crowded /  Not Crowded Filter
    if crowdlevel_value != nil

      @search_places.delete_if{|place|

        crowd = place.crowd_levels.where(hour: @hour, day: @day)
        density = crowd.first.crowd_density

        if crowdlevel_value == 'crowded'

         p density < 75
         
        elsif crowdlevel_value == 'not_crowded'

         p density > 25

        end
        
      }

    end  

    respond_to do |format|
      format.js   
    end

    # output_to_map.js.erb
  end

end
