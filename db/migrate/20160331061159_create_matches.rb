class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.column :redGoal, :integer
      t.column :blueGoal, :integer
      t.column :winner, :char, :limit => '1'
      t.timestamps null: false
    end
    
      change_column_null :matches, :redGoal, false
      change_column_null :matches, :blueGoal, false
      change_column_null :matches, :winner, false
  end
end
