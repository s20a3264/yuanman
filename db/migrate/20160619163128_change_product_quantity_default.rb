class ChangeProductQuantityDefault < ActiveRecord::Migration
  def change
  	change_column_default :products, :quantity,  1
  end
end
