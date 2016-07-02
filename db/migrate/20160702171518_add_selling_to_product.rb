class AddSellingToProduct < ActiveRecord::Migration
  def change
    add_column :products, :selling, :boolean, default: false
    add_index :products, :selling
  end
end
