module Api
  class GifsController < BaseController

    def show
      render json: Gif.getgifs(params[:q]).sample.to_json
    end
  end
end