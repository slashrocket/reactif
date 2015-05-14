class CreateTaglines < ActiveRecord::Migration
  def change
    create_table :taglines do |t|
      t.string :header
      t.string :query

      t.timestamps null: false
    end
  end
end
