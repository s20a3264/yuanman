class AddCategoryToProduct < ActiveRecord::Migration
  def change
  	add_column :products, :category, :string, index: true
  	change_column_default :orders, :undone, false
  end
end
