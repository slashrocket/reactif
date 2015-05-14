class CreateGifs < ActiveRecord::Migration
  def change
    create_table :gifs do |t|
      t.string :word
      t.string :url
      
      t.timestamps null: false
    end
    add_index :gifs, :word
    add_index :gifs, :url
  end
end
