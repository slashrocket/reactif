class DashboardController < ApplicationController
before_action :authenticate_user!
  def index
    @user = current_user
    @teams = current_user.teams
  end
end
