class PagesController < ApplicationController

  def index
  end

  def settings
  end

  def faq


  end

  def home
    @areas = Area.all
  end

  def output_to_map

  end

end
