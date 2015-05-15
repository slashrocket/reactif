class AddUserRefToTeams < ActiveRecord::Migration
  def change
    add_reference :teams, :user, index: true, foreign_key: true
  end
end
