class AddOtherPlayerToGameEvents < ActiveRecord::Migration
  def change
    add_column :game_events, :other_player_id, :integer
  end
end
