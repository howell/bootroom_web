class AddPlayerPlusGameIndexToGameEvents < ActiveRecord::Migration
  def change
    add_index :game_events, [:game_id, :player_id]
  end
end
