class SearchController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:slack]

  SLACK_WEBHOOK_URL = ENV['SLACK_WEBHOOK_URL'] # config/application.yml

  def index
  end

  def show
    @found_images = Gif.getgif(params[:search][:query])
  end

  def slack
    @text = params[:text].downcase
    @channel = params[:channel_name]
    @username = params[:user_name]
    @domain = params[:team_domain]
    found = find_gifs_for(@text, @domain, @channel, @username)
    found ? post_gif_to_slack(found, @text, @channel, @username) : no_gifs
  end

  private

  def find_gifs_for(query, domain, channel, username)
    if query == 'upvote'
      Teamgif.upvote(id, domain)
    elsif query == 'downvote'
      Teamgif.downvote(id, domain)
    end
    found = Gif.getgif(query)
    random_image = found.sample
    return random_image
  end
  

def post_gif_to_slack(image, text, channel, username)
  responselink = " /reactif " + text + "    <" + image + "?" + Random.rand(500).to_s + "|" + image + ">"
  responsechannel = "#" + channel
  HTTParty.post(SLACK_WEBHOOK_URL,
  {
    body: {
      payload: {
        username: username,
        channel: responsechannel,
        text: responselink
      }.to_json
    }
    })
  render :nothing => true
end

def no_gifs
  render json: 'No gifs found'
end

def vote(channel, id)
end
end