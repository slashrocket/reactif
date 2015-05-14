class SearchController < ApplicationController
  def index
  end

  def show
      @found = Scraper.getgif(params[:search][:query])
  end
end
