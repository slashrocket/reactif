class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @teamcount = Team.where('user_id = ?', @user.id).count
  end

  def settings
    @user = current_user
    @teams = current_user.teams
  end

  def api
    @user = current_user
  end

  def get_token
    @user = current_user
    @user.set_token
    respond_to do |format|
      format.js
    end
  end
end
