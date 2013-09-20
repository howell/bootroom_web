class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params)
    if @game.save
      cookies.permanent[:game_id] = @game.id
    end
      render 'new'
  end

  def show
    @game = Game.find(params[:id])
    unless params[:player_id].blank?
      @player = Player.find(params[:player_id])
    end
    @game_events = GameEvent.find_by(game_events_params)
  end

  private

    def game_params
      params.require(:game).permit(:home_team_id, :away_team_id,
                                   :home_final_score, :away_final_score)
    end

    def game_events_params
      unless params[:player_id].nil?
        { player_id: params[:player_id], game_id: params[:id] }
      else
        { game_id: params[:id] }
      end
    end
end
