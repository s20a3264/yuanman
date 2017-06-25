class AddColumnToSettings < ActiveRecord::Migration
  def change
  	add_column :settings, :about_us, :text
  	add_column :settings, :q_and_a, :text
  	add_column :settings, :notice, :text
  end
end
