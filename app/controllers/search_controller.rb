class SearchController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:slack]

  def index
  end

  def show
      @found = Scraper.getgif(params[:search][:query])
  end
  
  def slack
      @found = Scraper.getgif(params[:text])
      if @found.present?
        return render json: @found.first
      else
        return render json: "No gifs found"
      end
  end
end
