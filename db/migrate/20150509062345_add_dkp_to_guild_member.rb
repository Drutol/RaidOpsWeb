class AddDkpToGuildMember < ActiveRecord::Migration
  def change
    add_column :guild_members, :net, :integer
    add_column :guild_members, :tot, :integer
  end
end
