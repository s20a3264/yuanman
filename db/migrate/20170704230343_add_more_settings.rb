class AddMoreSettings < ActiveRecord::Migration
  def change
  	add_column :settings, :email, :string
  	add_column :settings, :line, :string
  	add_column :settings, :phone, :string
  	add_column :settings, :shipping_cost, :integer
  	add_column :settings, :shipping_free, :integer
  end
end
