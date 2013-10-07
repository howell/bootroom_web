class TeamsController < ApplicationController

  def index
    @teams = Team.paginate(page: params[:page])
  end

  def show
    @team = Team.find(params[:id])
    @players = @team.players
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      cookies.permanent[:team_id] = @team.id
    end
    render 'new'
  end

  private

    def team_params
      params.require(:team).permit(:name, :league)
    end

end
