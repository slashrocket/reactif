class HomeController < ApplicationController
  def index
    @tagline = Tagline.random
    redirect_to dashboard_path if current_user
  end
end
