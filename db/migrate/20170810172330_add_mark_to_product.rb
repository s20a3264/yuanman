class AddMarkToProduct < ActiveRecord::Migration
  def change
  	add_column :products, :mark, :boolean, default: false
  end
end
