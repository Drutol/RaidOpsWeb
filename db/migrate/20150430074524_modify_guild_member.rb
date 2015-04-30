class ModifyGuildMember < ActiveRecord::Migration
  def change
	rename_column :guild_members, :strRole, :str_role
	rename_column :guild_members, :strClass, :str_class
  end
end
