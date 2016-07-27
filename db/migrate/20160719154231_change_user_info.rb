class ChangeUserInfo < ActiveRecord::Migration
  def change
  	rename_column :users, :allow_use_of_info, :pre_use_info
  end
end
