class AddClassToGuildMember < ActiveRecord::Migration
  def change
    add_column :guild_members, :strClass, :string
  end
end
