class SearchController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:slack]

  SLACK_WEBHOOK_URL = ENV['slack_webhook_url'] # config/application.yml

  def index
  end

  def show
    find_gifs_for(params[:search][:query])
    @found = Scraper.getgif(params[:search][:query])
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
    @found_images = Scraper.get_gif(query)
    @found = Scraper.getgif(params[:text])
    @text = params[:text]
    @channel = params[:channel_name]
    @username = params[:user_name]
    @command = params[:command]
    @random_image = @found.sample
    if @found.present?
      @responselink = " /reactif " + @text + "    <" + @random_image + "?" + Random.rand(500).to_s + "|" + @random_image + ">"
      @responsechannel = "#" + @channel
      HTTParty.post(ENV['SLACK_WEBHOOK_URL'],
                    {
        body: {
          payload: {
            username: @username,
            channel: @responsechannel,
            text: @responselink
          }.to_json
        },
      })
      return render :nothing => true
    else
      return render json: "No gifs found"
    end
  end
end
