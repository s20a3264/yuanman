class AddSpecialPriceToProduct < ActiveRecord::Migration
  def change
  	add_column :products, :special_price, :integer
  	change_column_default :products, :price, 1
  end
end
