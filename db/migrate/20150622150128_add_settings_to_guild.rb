class AddSettingsToGuild < ActiveRecord::Migration
  def change
    add_column :guilds, :members_per_page, :integer
    add_column :guilds, :items_per_page, :integer
    add_column :guilds, :pr_precision, :integer
  end
end
