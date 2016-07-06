class CreateTradeInfos < ActiveRecord::Migration
  def change
    create_table :trade_infos do |t|
      t.jsonb :pay_info
      t.references :order, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
