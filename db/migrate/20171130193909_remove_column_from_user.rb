class RemoveColumnFromUser < ActiveRecord::Migration
  def change
  	remove_column :users, :pre_use_info
  end
end
