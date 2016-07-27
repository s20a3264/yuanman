class AddPendingToOrder < ActiveRecord::Migration
  def change
  	add_column :orders, :undone, :boolean, default: true
 		add_index :orders, :undone
  end
end
