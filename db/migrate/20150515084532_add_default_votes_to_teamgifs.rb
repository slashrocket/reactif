class AddDefaultVotesToTeamgifs < ActiveRecord::Migration
  def change
    change_column :teamgifs, :votes, :integer, default: 25
  end
end
