class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :home_team_id
      t.integer :away_team_id
      t.integer :home_final_score
      t.integer :away_final_score

      t.timestamps
    end
    add_index :games, :home_team_id
    add_index :games, :away_team_id
    add_index :games, [:home_team_id, :away_team_id]
  end
end
