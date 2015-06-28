class SearchController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:slack]

  def index
  end

  def show
    @found = Gif.getgifs(params[:search][:query])
  end

  def slack
    return render json: 'Team not found' unless team
    return no_gifs unless process_command
    render nothing: true
  end

  private

  def process_command
    if (text =~ /^(upvote|downvote)$/).present?
      vote
    else
      found_gif = find_gif
      return false unless found_gif
      post_gif_to_slack(found_gif, text, channel, username)
    end
    true
  end

  def find_gif
    return false if (gifs.empty?) || (!gifs.sample.instance_of? Gif)
    store_teamgifs
    select_random_gif
  end

  def store_teamgifs
    team.gifs << gifs.reject { |gif| team.gifs.include?(gif) }
  end

  def select_random_gif
    gifs.find { |g| g.id == teamgifs.random_gif_id }
  end

  def post_gif_to_slack(gif, text, channel, username)
    store_last_gif_data gif.id
    SlackPoster.new(text, gif, username, channel, team).post_gif
  end

  def no_gifs
    render json: 'No gifs found'
  end

  def store_last_gif_data(gif_id)
    last_gif.try(:delete)
    Lastgif.create team_domain: team.domain, channel: channel, gif_id: gif_id
  end

  def last_gif
    @last_gif ||= Lastgif.find(team_domain: team.domain, channel: channel).first
  end

  def vote
    return false if already_voted?(last_teamgif.id)
    last_teamgif.send(text)
    create_gifvote(last_teamgif.id)
    post_vote_to_slack
  end

  def post_vote_to_slack
    SlackPoster.new(text, last_teamgif, username, channel, team).post_vote
  end

  def last_teamgif
    @teamgif ||= team.teamgifs.find_by(gif_id: last_gif.gif_id)
  end

  def create_gifvote(gif_id)
    Gifvotes.create team_domain: team.domain,
                    channel: channel,
                    username: username,
                    gif_id: gif_id,
                    expiration: Time.now + 1.week
  end

  def already_voted?(gif_id)
    vote = Gifvotes.find(team_domain: domain,
                         channel: channel,
                         username: username,
                         gif_id: gif_id).first
    if vote.present? && vote.expiration <= Time.now
      vote.delete
      vote = nil
    end
    !vote.nil?
  end

  def text
    params[:text].downcase
  end

  def channel
    params[:channel_name]
  end

  def username
    params[:user_name]
  end

  def domain
    params[:team_domain]
  end

  def team
    @team ||= Team.find_by_domain domain
  end

  def gifs
    @gifs ||= Gif.getgifs(text)
  end

  def teamgifs
    @teamgifs ||= team.teamgifs.where(gif_id: gifs.map(&:id))
  end
end
