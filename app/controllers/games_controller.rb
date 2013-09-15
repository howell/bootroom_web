class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params)
    if @game.save
      cookies.permanent[:game_id] = @game.id
      redirect_to @game
    else
      render 'new'
    end
  end

  def show
    @game = Game.find(params[:id])
  end

  private

    def game_params
      params.require(:game).permit(:home_team_id, :away_team_id,
                                   :home_final_score, :away_final_score)
    end
end
