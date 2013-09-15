class CreateGameEvents < ActiveRecord::Migration
  def change
    create_table :game_events do |t|
      t.integer :timestamp
      t.integer :player_id
      t.integer :game_id
      t.integer :event_type
      t.integer :event_subtype

      t.timestamps
    end
    add_index :game_events, :player_id
    add_index :game_events, :game_id
  end
end
