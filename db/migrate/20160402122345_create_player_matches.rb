class CreatePlayerMatches < ActiveRecord::Migration
  def change
    create_table :player_matches do |t|
      t.column :player_id, :integer
      t.column :match_id, :integer
      t.column :team, :char, :limit => '1'
      t.column :position, :string, :limit => '3'
      t.timestamps null: false
  end

  change_column_null :player_matches, :player_id, false
  change_column_null :player_matches, :match_id, false
  change_column_null :player_matches, :team, false
  change_column_null :player_matches, :position, false
  add_foreign_key :player_matches, column: :player_id
  add_foreign_key :player_matches, column: :match_id
  end
end
