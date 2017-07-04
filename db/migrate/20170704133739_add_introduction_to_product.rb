class AddIntroductionToProduct < ActiveRecord::Migration
  def change
  	add_column :products, :introduction,    :text
  	add_column :products, :origin,          :string
  	add_column :products, :weight,          :string
  	add_column :products, :expiration_date, :string
  end
end
