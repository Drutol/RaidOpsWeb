class AddSettingLastUpdateToGuild < ActiveRecord::Migration
  def change
    add_column :guilds, :display_last_update, :boolean
  end
end
