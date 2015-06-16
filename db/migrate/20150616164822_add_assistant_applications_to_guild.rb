class AddAssistantApplicationsToGuild < ActiveRecord::Migration
  def change
    add_column :guilds, :ass_app, :string
  end
end
