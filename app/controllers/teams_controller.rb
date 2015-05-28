class TeamsController < ApplicationController
  before_action :authenticate_user!
  def new
    @team = current_user.teams.build
    respond_to do |format|
      format.js
    end
  end

  def create
    @team = current_user.teams.build(team_params)
    if @team.save
      flash[:notice] = 'Team added!'
      redirect_to dashboard_path
    else
      flash[:alert] = 'Failed to add team'
      redirect_to dashboard_path
    end
  end

  def destroy
    current_user.teams.find(params[:id]).destroy
    flash[:success] = 'Team deleted.'
    redirect_to dashboard_path
  end

  def edit
    @team = current_user.teams.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update
    @team = current_user.teams.find(params[:id])
    if @team.update_attributes(team_params)
      flash[:success] = "Team updated!"
      redirect_to dashboard_path
    else
      flash[:alert] = "Failed to update team"
      redirect_to dashboard_path
    end
  end

  private
    def team_params
      params.require(:team).permit(:name, :domain, :webhook)
    end
end