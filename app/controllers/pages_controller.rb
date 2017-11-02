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

    area_value = params[:area_checkbox]
    search_result = params[:search_result]
    crowdlevel = params[:crowdlevel]
    datetime = params[:date_time]

    @areas = Area.where(name: area_value)  
    # render "pages/home"  

    respond_to do |format|
      format.js   
    end

    # output_to_map.js.erb
  end

end
