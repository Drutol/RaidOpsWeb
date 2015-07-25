class RenameMemberIdColumnInDataSet < ActiveRecord::Migration
  def change
	rename_column :data_sets, :GuildMember_id, :guild_member_id
  end
end
