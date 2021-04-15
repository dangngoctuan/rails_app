class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :fb_id
      t.string :name
      t.text :image_url
      t.timestamps
    end
  end
end
