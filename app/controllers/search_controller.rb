class SearchController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:slack]

  SLACK_WEBHOOK_URL = ENV['SLACK_WEBHOOK_URL'] # config/application.yml

  def index
  end

  def show
    @found = Gif.getgif(params[:search][:query])
  end

  def slack
    text = params[:text].downcase
    channel = params[:channel_name]
    username = params[:user_name]
    domain = params[:team_domain]
    @team = Team.find_by_domain(domain);
    if @text == 'upvote' || @text == 'downvote'
      vote text, domain, channel
    else
      found = find_gifs_for(text)
      found ? post_gif_to_slack(found, text, channel, username) : no_gifs
    end
  end

  private

  def find_gifs_for(query)
    found = Gif.getgif(query)
    random_image = found.sample
    @gif = Gif.find_by_url(found.sample)
    @team.gifs << @gif
    return @gif
  end
  

  def post_gif_to_slack(image, text, channel, username)
    responselink = "<" + image.url + "?" + Random.rand(500).to_s + "|" + " /reactif " + text + ">"
    responsechannel = "#" + channel
    store_last_gif_data @team.domain, channel, image.id
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

  def store_last_gif_data(team_domain, channel, gif_id)
    Lastgif.find(team_domain: team_domain, channel: channel).first.delete
    Lastgif.create team_domain: team_domain, channel: channel, gif_id: gif_id
  end

  def last_gif_id(team_domain, channel)
    last_gif = Lastgif.find(team_domain: team_domain, channel: channel).first
    return last_gif.id
  end

  def vote(query, domain, channel)
    @team = Team.find_by_domain(domain)
    @gif = @team.gifs.find(last_gif_id(domain, channel))
    if query == 'upvote'
      @gif.upvote
    elsif query == 'downvote'
      @gif.downvote
    end
  end

end