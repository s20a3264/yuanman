class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :carousel1
      t.string :carousel2
      t.string :carousel3

      t.timestamps null: false
    end
  end
end
