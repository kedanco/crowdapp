class PagesController < ApplicationController

  def index
  end

  def settings
  end

  def faq


  end

  def home
    @areas = Area.all

    # @district_names = ImportService.initDistrict
    # @district_names = District.select(:name)
    
  end

  def output_to_map

  end

end
