class AddShippingCostAndPointsToOrder < ActiveRecord::Migration
  def change
  	add_column :orders, :points, :integer, default: 0
  	add_column :orders, :shipping_cost, :integer
  end
end
