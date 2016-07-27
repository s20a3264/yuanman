class AddInfoToUser < ActiveRecord::Migration
  def change
  	add_column :users, :info, :jsonb, default: '{}'
  	add_column :users, :allow_use_of_info, :boolean, default: true
  	add_index :users, :allow_use_of_info
  end
end
