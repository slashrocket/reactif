class SearchController < ApplicationController
  include SlackHelper

  skip_before_filter :verify_authenticity_token, only: [:slack]

  def index
  end

  def show
    @found = Gif.getgifs(params[:search][:query])
  end

  def slack
    query, channel, username, domain = params[:text].downcase, params[:channel_name], params[:user_name], params[:team_domain]
    team = Team.find_by(domain: domain)
    return no_team unless team

    if !!(text =~ /^(upvote|downvote)$/)
      vote_gif(query, team, channel)
    else
      post_gif(query, team, channel, username)
    end

  end

  private

  def find_gifs_for(query, team)
    gifs = Gif.getgifs(query)
    return false if gifs.present?
    team.gifs << gifs.reject { |gif| team.gifs.include?(gif) }

    pick_random(team, gifs)
  end

  # a pick random gif function that takes the votes into account
  def pick_random(team, gifs)
    team_gifs = team.teamgifs.where(gif_id: gifs.map(&:id))
    total_votes = team_gifs.pluck(:votes).sum(&:to_i)

    gifs.detect { |gif| gif.id == ranged_pairs(team_gifs, total_votes) }
  end

  def ranged_pairs(team_gifs, total_votes)
    total = 0

    team_gifs.map { |gif| [gif.gif_id, total += gif.votes * 100 / total_votes] }
             .to_h
             .select { |_key, value| rand(100) <= value }
             .keys.first
  end

  def store_last_gif_data(team, channel, gif_id)
    get_last_gif(team.domain, channel).try(:delete)
    Lastgif.create(team_domain: team.domain, channel: channel, gif_id: gif_id)
  end

  def get_last_gif(team, channel)
    Lastgif.find_by(team_domain: team.domain, channel: channel)
  end

  def no_gifs
    render json: 'No gifs found :('
  end

  def no_team
    render json: 'Team not found :('
  end
end
