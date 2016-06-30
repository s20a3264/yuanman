class AddOrderNumberToOrder < ActiveRecord::Migration
  def change
  	add_column :orders, :order_number, :string
  	add_index :orders, :order_number
  end
end
