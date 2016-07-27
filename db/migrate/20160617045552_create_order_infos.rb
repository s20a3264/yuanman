class CreateOrderInfos < ActiveRecord::Migration
  def change
    create_table :order_infos do |t|
      t.integer :order_id
      t.string :shipping_name
      t.string :shipping_address

      t.timestamps null: false
    end
  end
end
