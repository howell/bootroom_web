class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :first_name
      t.string :last_name
      t.integer :number
      t.string :email
      t.integer :team_id

      t.timestamps
    end
    add_index :players, :team_id
  end
end
