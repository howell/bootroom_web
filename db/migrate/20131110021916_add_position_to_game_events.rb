class AddPositionToGameEvents < ActiveRecord::Migration
  def change
    add_column :game_events, :position, :string
  end
end
