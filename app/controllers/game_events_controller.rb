class GameEventsController < ApplicationController

  respond_to :html, :json

  def new
    @game_event = GameEvent.new
  end

  def create
    @game_event = GameEvent.create(game_event_params)
    if @game_event.save
      respond_with @game_event
    else
      render 'new'
    end
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
