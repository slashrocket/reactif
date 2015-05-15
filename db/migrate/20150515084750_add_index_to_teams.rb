class AddIndexToTeams < ActiveRecord::Migration
  def change
    add_index :teams, :domain
  end
end
