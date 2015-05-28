module Api
  class GifsController < BaseController

    def show
      user = User.find_by_token(params[:token])
      if user && ActiveSupport::SecurityUtils.secure_compare(user.token, params[:token])
        render json: Gif.getgifs(params[:q]).sample.to_json
      else
        render status: 401, json: { success: false, info: "Invalid or Missing"}
      end
    end
  end
end