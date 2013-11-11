class GameEventsController < ApplicationController
  def new
    @game_event = GameEvent.new
  end

  def create
    @game_event = GameEvent.create(game_event_params)
    if @game_event.save
    end
      render 'new'
  end

  def show
    @game_event = GameEvent.find(params[:id])
  end

  private

    def game_event_params
      params.require(:game_event).permit(:timestamp, :player_id,
                                         :game_id, :event_type,
                                         :event_subtype, :other_player_id,
                                         :position)
    end

end
