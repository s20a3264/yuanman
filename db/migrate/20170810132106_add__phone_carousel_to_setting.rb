class AddPhoneCarouselToSetting < ActiveRecord::Migration
  def change
  	add_column :settings, :carousel1_p, :string
  	add_column :settings, :carousel2_p, :string
  	add_column :settings, :carousel3_p, :string
  	add_column :settings, :carousel1_link_p, :string
  	add_column :settings, :carousel2_link_p, :string
  	add_column :settings, :carousel3_link_p, :string
  end
end
