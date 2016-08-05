class AddColumnToOrderInfo < ActiveRecord::Migration
  def change
  	add_column :order_infos, :postal_code, :string
  	add_column :order_infos, :phone_number, :string
  end
end
