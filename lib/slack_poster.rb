class SlackPoster

  def initialize(query, gif, username, channel, team)
    @query = query
    @gif = gif
    @username =username
    @channel = channel
    @team = team
  end

  def post_gif
    @responselink = '<' + @gif.url + '?' + Random.rand(500).to_s + '|' + ' /reactif ' + @gif.word + '>'
    post
  end

  def post_vote
    @responselink = 'The previous gif was ' + @query + 'd, ' + 'total votes: ' + @gif.votes.to_s
    post
  end

  def post_body
    {
      payload: {
        username: @username,
        channel: "##{@channel}",
        text: @responselink
      }.to_json
    }
  end  

  def post
    HTTParty.post(@team.webhook, body: post_body)
  end
end
