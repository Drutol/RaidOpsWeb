class AddEditFlagToGuildMember < ActiveRecord::Migration
  def change
    add_column :guild_members, :edit_flag, :integer
  end
end
