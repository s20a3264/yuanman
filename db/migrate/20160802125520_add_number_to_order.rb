class AddNumberToOrder < ActiveRecord::Migration
  def change
  	add_column :orders, :payment_info, :jsonb
  end
end
