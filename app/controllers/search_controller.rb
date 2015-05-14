class SearchController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:slack]

  SLACK_WEBHOOK_URL = ENV['slack_webhook_url'] # config/application.yml

  def index
  end

  def show
    @found = Gif.getgif(params[:search][:query])
  end

  def slack
    find_gifs_for(params[:text])

    @text = params[:text]
    @channel = params[:channel_name]
    @username = params[:user_name]
    @command = params[:command]
    @random_image = @found_images.sample

    @found_images.present? ? slack_response_gifs : no_gifs
  end

  private

  def slack_response_gifs
    @response_link = ' /reactif ' + @text + '    <' + @random_image + '?' + Random.rand(500).to_s + '|' + @random_image + '>'
    @response_channel = '#' + @channel
    HTTParty.post(SLACK_WEBHOOK_URL,
                  body: {
      payload: {
        username: @username,
        channel: @response_channel,
        text: @response_link
      }.to_json
    })
    render nothing: true
  end

  def no_gifs
    render json: 'No gifs found'
  end

  def find_gifs_for(query)
    @found = Gif.getgif(params[:text])
    @text = params[:text].downcase
    @channel = params[:channel_name]
    @username = params[:user_name]
    @command = params[:command]
    @domain = params[:team_domain]
    if @text == 'upvote'
      Teamgif.upvote(id, @domain)
    elsif @text == 'downvote'
      Teamgif.downvote(id, @domain)
    end
    @random_image = @found.sample
    if @found.present?
      post_gif_to_slack @random_image, @text, @channel, @username
    else
      return render json: "No gifs found"
    end
  end
end

private

def post_gif_to_slack(image, text, channel, username)
  responselink = " /reactif " + text + "    <" + image + "?" + Random.rand(500).to_s + "|" + image + ">"
  responsechannel = "#" + channel
  HTTParty.post(ENV['SLACK_WEBHOOK_URL'],
                <<<<<<< HEAD
  {
    body: {
      payload: {
        username: username,
        channel: responsechannel,
        text: responselink
      }.to_json
    },
    =======
    {
      body: {
        payload: {
          username: username,
          channel: responsechannel,
          text: responselink
        }.to_json
      },
      >>>>>>> 63e78b5d2bf67a5a05a48d283223f9aeb31b0478
    })
  return render :nothing => true
end

def vote(channel, id)
  <<<<<<< HEAD

end
=======

end
>>>>>>> 63e78b5d2bf67a5a05a48d283223f9aeb31b0478
