class AddColumnToProduct < ActiveRecord::Migration
  def change
  	add_column :products, :certification, :string
  	add_column :products, :nutrition_facts, :string
  end
end
