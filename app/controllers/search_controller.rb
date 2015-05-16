class SearchController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:slack]

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
    @team = Team.find_by_domain(domain)
    if @team
      if text == 'upvote' || text == 'downvote'
        vote text, domain, channel
      else
        found = find_gifs_for(text)
        found ? post_gif_to_slack(found, text, channel, username) : no_gifs
      end
    end
    render :nothing => true
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
    asd = HTTParty.post(@team.webhook,
    {
      body: {
        payload: {
          username: username,
          channel: responsechannel,
          text: responselink
        }.to_json
      }
      })
  end

  def no_gifs
    render json: 'No gifs found'
  end

  def store_last_gif_data(team_domain, channel, gif_id)
    last = Lastgif.find(team_domain: team_domain, channel: channel).first
    last.delete unless last == nil 
    Lastgif.create team_domain: team_domain, channel: channel, gif_id: gif_id
  end

  def get_last_gif(team_domain, channel)
    last_gif = Lastgif.find(team_domain: team_domain, channel: channel).first
    return last_gif
  end

  def vote(query, domain, channel)
    @team = Team.find_by_domain(domain)
    last_gif = get_last_gif domain, channel
    unless last_gif == nil
      @gif = @team.teamgifs.find(last_gif.gif_id)
      if query == 'upvote'
        @gif.upvote
      elsif query == 'downvote'
        @gif.downvote
      end
    end
  end

end