class PagesController < ApplicationController

  def index
  end

  def settings
  end

  def faq

  def home
    @areas = Area.all

  end
end
