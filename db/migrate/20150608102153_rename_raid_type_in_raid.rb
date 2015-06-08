class RenameRaidTypeInRaid < ActiveRecord::Migration
  def change
 	rename_column :raids, :nRaidType, :raid_type
  end
end
