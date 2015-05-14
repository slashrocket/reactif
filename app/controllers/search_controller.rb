class SearchController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:slack]
  require 'json'
  require 'httparty'

  def index
  end

  def show
      @found = Scraper.getgif(params[:search][:query])
  end
  
  def slack
      @found = Scraper.getgif(params[:text])
      @channel = params[:channel_name]
      if @found.present?
        @responselink = "<" + @found.first + "|" + @found.first + ">"
        @responsechannel = "#" + @channel
        HTTParty.post(ENV['SLACK_WEBHOOK_URL'],
        {
        body: {
          payload: {
            channel: @responsechannel,
            text: @responselink
          }.to_json
        },
        })
        return render json: @found.first
      else
        return render json: "No gifs found"
      end
  end
end
