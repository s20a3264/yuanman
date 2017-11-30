class AddSpecialToProduct < ActiveRecord::Migration
  def change
  	add_column :products, :special, :boolean, default: false
  	add_index  :products, :special
  end
end
