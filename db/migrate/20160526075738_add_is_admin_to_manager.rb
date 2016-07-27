class AddIsAdminToManager < ActiveRecord::Migration
  def change
  	add_column :managers, :is_admin, :boolean, default: false
  end
end
