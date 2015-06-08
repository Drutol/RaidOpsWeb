class RenameRaidTypeInAtt < ActiveRecord::Migration
  def change
     rename_column :attendances, :nRaidType, :raid_type
  end
end
