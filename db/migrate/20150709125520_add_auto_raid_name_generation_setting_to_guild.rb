class AddAutoRaidNameGenerationSettingToGuild < ActiveRecord::Migration
  def change
    add_column :guilds, :auto_raid_name, :string , :default => "Auto"
  end
end
