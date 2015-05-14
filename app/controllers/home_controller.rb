class HomeController < ApplicationController
  def index
    if current_user then return redirect_to dashboard_path end
    @tagline = Tagline.random
  end
end
