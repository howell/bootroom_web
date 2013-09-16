class PlayersController < ApplicationController
  def new
    @player = Player.new
  end

  def create
    @team = Team.find(params[:player][:team_id])
    @player = @team.players.build(player_params)
    @player.save
    render 'new'
  end

  def show
    @player = Player.find(params[:id])
  end

  private

    def player_params
      params[:player].permit(:first_name, :last_name, :number, :email)
    end
end
