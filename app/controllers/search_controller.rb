class SearchController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:slack]

  def index
  end

  def show
      @found = Scraper.getgif(params[:search][:query])
  end
  
  def slack
      @found = Scraper.getgif(params[:text])
      @channel = params[:channel_name]
      if @found.present?
        return render 'slackresponse.js.erb' 
        #return render json: @found.first
      else
        return render json: "No gifs found"
      end
  end
end
