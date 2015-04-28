class AddRoleToGuildMember < ActiveRecord::Migration
  def change
    add_column :guild_members, :strRole, :string
  end
end
