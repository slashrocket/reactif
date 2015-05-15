class AddWebhookToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :webhook, :string
  end
end
