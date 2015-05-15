class AddDomainToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :domain, :string
  end
end
