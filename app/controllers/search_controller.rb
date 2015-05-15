class SearchController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:slack]

  SLACK_WEBHOOK_URL = ENV['SLACK_WEBHOOK_URL'] # config/application.yml

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
    if @text == 'upvote' || @text == 'downvote'
      vote @text, id, @domain
    else
      found = find_gifs_for(@text, @domain, @channel, @username)
      found ? post_gif_to_slack(found, @text, @channel, @username) : no_gifs
    end
  end

  private

  def find_gifs_for(query, domain, channel, username)
    found = Gif.getgif(query)
    random_image = found.sample
    return random_image
  end
  

  def post_gif_to_slack(image, text, channel, username)
    responselink = "<" + image + "?" + Random.rand(500).to_s + "|" + " /reactif " + text + ">"
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

  def vote(query,id, domain)
    if query == 'upvote'
      Teamgif.upvote(id, domain)
    elsif query == 'downvote'
      Teamgif.downvote(id, domain)
    end
  end

end