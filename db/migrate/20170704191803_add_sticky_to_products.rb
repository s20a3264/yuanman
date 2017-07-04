class AddStickyToProducts < ActiveRecord::Migration
  def change
  	add_column :articles, :sticky, :integer, default: 0
  end
end
