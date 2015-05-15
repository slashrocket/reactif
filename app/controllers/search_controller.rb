class SearchController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:slack]

  SLACK_WEBHOOK_URL = ENV['slack_webhook_url'] # config/application.yml

  def index
  end

  def show
    @found = Gif.getgif(params[:search][:query])
  end

  def slack
    @text = params[:text].downcase
    @channel = params[:channel_name]
    @username = params[:user_name]
    @domain = params[:team_domain]
    find_gifs_for(@text, @domain, @channel, @username)
    @random_image = @found_images.sample
    @found_images.present? ? slack_response_gifs : no_gifs
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
    if found.present? ? post_gif_to_slack(random_image, query, channel, username) : no_gifs
      post_gif_to_slack random_image, query, channel, username
    else
      return render json: "No gifs found"
    end
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
  return render :nothing => true
end

def no_gifs
  return render json: 'No gifs found'
end

def vote(channel, id)
end
end