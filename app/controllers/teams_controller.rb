class TeamsController < ApplicationController
  before_action :authenticate_user!

  def create
    @team = current_user.teams.build(team_params)
    if @team.save!
      flash[:notice] = 'Team added!'
      redirect_to dashboard_path
    end
  end

  def destroy
    current_user.teams.find(params[:id]).destroy
    flash[:notice] = 'Team deleted.'
    redirect_to dashboard_path
  end

  private
    def team_params
      params.require(:team).permit(:name, :domain, :webhook)
    end
end