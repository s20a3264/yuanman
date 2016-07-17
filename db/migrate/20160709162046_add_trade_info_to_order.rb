class AddTradeInfoToOrder < ActiveRecord::Migration
  def change
  	add_column :orders, :trade_info, :jsonb, default: '{}'
  	add_index :orders, :trade_info
  end
end
