class PagesController < ApplicationController
  def home
    @areas = Area.all
  end
end
