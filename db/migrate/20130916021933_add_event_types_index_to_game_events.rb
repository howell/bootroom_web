class AddEventTypesIndexToGameEvents < ActiveRecord::Migration
  def change
    add_index :game_events, :event_type
    add_index :game_events, [:event_type, :event_subtype]
  end
end
