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
    @districts = District.all

    area_value = params[:area_checkbox]
    search_place = params[:search_result]
    crowdlevel = params[:crowdlevel]
    datetime = params[:date_time]

    if search_place != "" then 
      @search_place = Place.where("name ilike ?", "%#{search_place}%")
      
      if @search_place ==[]
        # display msgbox when query database not found
      end

      else
        # display msgbox when click blank in search
    end

    @areas = Area.where(name: area_value)  
    # render "pages/home"  

    respond_to do |format|
      format.js   
    end

    # output_to_map.js.erb
  end

end
