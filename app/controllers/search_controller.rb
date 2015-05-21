class SearchController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:slack]

  def index
  end

  def show
    @found = Gif.getgifs(params[:search][:query])
  end

  def slack
    text, channel, username, domain = params[:text].downcase, params[:channel_name], params[:user_name], params[:team_domain]
    @team = Team.find_by_domain domain
    return render json: 'Team not found' unless @team
    if !!(text =~ /^(upvote|downvote)$/)
      vote text, domain, channel, username
    else
      found = find_gifs_for text
      return no_gifs unless found
      post_gif_to_slack(found, text, channel, username)
    end
    return render nothing: true
  end

  private

  def find_gifs_for(query)
    @gifs = Gif.getgifs(query)
    return false if (@gifs.empty?) || (!@gifs.sample.instance_of? Gif)
    @team.gifs << @gifs.reject { |gif| @team.gifs.include?(gif) }
    @gif = pick_random
    @gif
  end

  # a pick raondom gif function that takes the votes into account
  def pick_random
    id_array = @gifs.map(&:id)
    @teamgifs = @team.teamgifs.where(gif_id: id_array )
    @total_votes = @teamgifs.map(&:votes).inject(0, &:+)
    @total = 0 # makes this variable aviable in the map
    # hacky way to pair gif_ids with their total of votes as a %
    range_pairs = @teamgifs.collect.map{ |gif| [gif.gif_id, @total += gif.votes * 100 / @total_votes] }.to_h
    @random_number = rand(0..100) # make the random number avaible to the select
    @selected_id = range_pairs.select { |_key, value| @random_number <= value }.keys.first
    choosen_gif = @gifs.select{ |gif| gif.id == @selected_id }.first
    choosen_gif
  end
  
  def post_gif_to_slack(image, text, channel, username)
    store_last_gif_data @team.domain, channel, image.id
    responselink = '<' + image.url + '?' + Random.rand(500).to_s + '|' + ' /reactif ' + text + '>'
    post_to_slack @team.webhook, username, channel, responselink
  end

  def no_gifs
    render json: 'No gifs found'
  end

  def store_last_gif_data(team_domain, channel, gif_id)
    last = Lastgif.find(team_domain: team_domain, channel: channel).first
    last.delete unless last.nil? 
    Lastgif.create team_domain: team_domain, channel: channel, gif_id: gif_id
  end

  def get_last_gif(team_domain, channel)
    last_gif = Lastgif.find(team_domain: team_domain, channel: channel).first
    last_gif
  end

  def vote(query, domain, channel, username)
    @team = Team.find_by_domain domain
    last_gif = get_last_gif domain, channel
    return false if last_gif.nil? 
    @gif = @team.teamgifs.find_by_gif_id(last_gif.gif_id)
    return false if arleady_voted? domain, channel, username, @gif.id
    if query == 'upvote'
      @gif.upvote
    elsif query == 'downvote'
      @gif.downvote
    end
    Gifvotes.create team_domain: domain, channel: channel, username: username, gif_id: @gif.id, expiration: Time.now + 1.week
    responselink = 'The previous gif was ' + query + 'd, ' + 'total votes: ' + @gif.votes.to_s
    post_to_slack @team.webhook, 'Reactif', channel, responselink
  end

  def arleady_voted?(domain, channel, username, gif_id)
    vote = Gifvotes.find(team_domain: domain, channel: channel, username: username, gif_id: gif_id).first
    if vote.present? && vote.expiration <= Time.now
      vote.delete
      vote = nil
    end
    return !!vote
  end

  def post_to_slack(webhook, username, channel, responselink)
    responsechannel = '#' + channel
    HTTParty.post(webhook,
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

end