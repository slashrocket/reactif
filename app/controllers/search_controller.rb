class SearchController < ApplicationController
  def index
  end

  def show
      @found = Scraper.getgif(params[:search][:query])
  end
  
  def slack
      @found = Scraper.getgif(params[:text]).first
      return render json: @found
  end
end
