class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
	  t.column :name, :string
	  t.column :alias, :string, :limit=>'5'
	  t.timestamps null: false
	end
	
    change_column_null :players, :name, false
    change_column_null :players, :alias, false
  end
end
