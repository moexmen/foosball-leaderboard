class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.column :wins, :integer
      t.column :loses, :integer
      t.column :points, :integer
      t.column :goals, :integer
      t.column :wRatio, :float
      t.column :pullUps, :integer
      t.column :win_streak, :integer
      t.column :longest_win_streak, :integer
      t.column :player_id, :integer
      t.timestamps null: false
    end

      change_column_null :scores, :wins, false
      change_column_null :scores, :loses, false
      change_column_null :scores, :points, false
      change_column_null :scores, :goals, false
      change_column_null :scores, :wRatio, false
      change_column_null :scores, :pullUps, false
      change_column_null :scores, :win_streak, false
      change_column_null :scores, :longest_win_streak, false
      change_column_null :scores, :player_id, false
      add_foreign_key :scores, column: :player_id
  end
end
