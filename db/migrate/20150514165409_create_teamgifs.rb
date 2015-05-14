class CreateTeamgifs < ActiveRecord::Migration
  def change
    create_table :teamgifs do |t|
      t.references :gif, index: true, foreign_key: true
      t.references :team, index: true, foreign_key: true
      t.integer :votes

      t.timestamps null: false
    end
  end
end
