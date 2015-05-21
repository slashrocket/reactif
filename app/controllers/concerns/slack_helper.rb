module SlackHelper
  def post_gif(query, team, channel, username)
    found_gif = find_gifs_for(query, team)
    return no_gifs unless found_gif
    response_link = "<#{found_gif.url}?#{rand(500)}| /reactif #{text}>"

    store_last_gif_data(team, channel, found_gif.id)
    post_to_slack(team.webhook, username, channel, response_link)
  end

  def vote_gif(query, team, channel)
    last_gif = get_last_gif(team, channel)
    return false if last_gif.nil?
    gif = team.teamgifs.find_by(gif_id: last_gif.gif_id)
    query == 'upvote' ? gif.upvote! : gif.downvote!

    response_link = "The previous gif was #{query}d, total votes: #{gif.votes}"
    post_to_slack(team.webhook, 'Reactif', channel, response_link)
  end

  def post_to_slack(webhook, username, channel, response_link)
    HTTParty.post(webhook,
                  {
                      body: {
                          payload: {
                                       username: username,
                                       channel: "##{channel}",
                                       text: response_link
                                   }.to_json
                      }
                  })
  end
end
