class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.column :wins, :integer
      t.column :loses, :integer
      t.column :points, :integer
      t.column :goals, :integer
      t.column :wRatio, :float
      t.column :pullUps, :integer
      t.timestamps null: false
      end

      change_column_null :scores, :wins, false
      change_column_null :scores, :loses, false
      change_column_null :scores, :points, false
      change_column_null :scores, :goals, false
      change_column_null :scores, :wRatio, false
      change_column_null :scores, :pullUps, false
    
  end
end
