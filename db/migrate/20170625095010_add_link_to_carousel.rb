class AddLinkToCarousel < ActiveRecord::Migration
  def change
  	add_column :settings, :carousel1_link, :string
  	add_column :settings, :carousel2_link, :string
  	add_column :settings, :carousel3_link, :string
  end
end
