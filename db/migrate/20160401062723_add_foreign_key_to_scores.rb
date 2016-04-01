class AddForeignKeyToScores < ActiveRecord::Migration
  def change
  	add_column :scores, :player_id, :INTEGER
  	add_foreign_key :scores, column: :player_id

   	change_column_null :scores, :player_id, false
  end
end
