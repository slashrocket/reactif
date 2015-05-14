class SearchController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:slack]
  require 'json'
  require 'httparty'

  def index
  end

  def show
      @found = Gif.getgif(params[:search][:query])
  end
  
  def slack
      @found = Gif.getgif(params[:text])
      @text = params[:text].downcase
      @channel = params[:channel_name]
      @username = params[:user_name]
      @command = params[:command]
      if @text == 'upvote'
        Teamgif.upvote(id, team)
      elsif @text == 'downvote'
        Teamgif.downvote(id, team)
      end
      @random_image = @found.sample
      if @found.present?
        post_gif_to_slack @random_image, @text, @channel, @username
      else
        return render json: "No gifs found"
      end
  end
end

private

def post_gif_to_slack(image, text, channel, username)
  responselink = " /reactif " + text + "    <" + image + "?" + Random.rand(500).to_s + "|" + image + ">"
  responsechannel = "#" + channel
  HTTParty.post(ENV['SLACK_WEBHOOK_URL'],
  {
  body: {
    payload: {
      username: username,
      channel: responsechannel,
      text: responselink
    }.to_json
  },
  })
  return render :nothing => true
end

def vote(channel, id)
  
end