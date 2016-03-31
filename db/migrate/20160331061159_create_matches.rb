class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.column :redAtt, :integer
      t.column :redDef, :integer
      t.column :blueAtt, :integer
      t.column :blueDef, :integer
      t.column :redGoal, :integer
      t.column :blueGoal, :integer
      t.column :winner, :integer, :limit => '1'
      t.timestamps null: false
    end

      change_column_null :matches, :redAtt, true
      change_column_null :matches, :redDef, true
      change_column_null :matches, :blueAtt, true
      change_column_null :matches, :blueDef, true
      change_column_null :matches, :redGoal, false
      change_column_null :matches, :blueGoal, false
      change_column_null :matches, :winner, false
  end
end
