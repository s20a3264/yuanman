class ChangeColumnDefaultForTradeInfo < ActiveRecord::Migration
  def change
  	change_column_default :trade_infos, :pay_info, '{}'
  end
end
