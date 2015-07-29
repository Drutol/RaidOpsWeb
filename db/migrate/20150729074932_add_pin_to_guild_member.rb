class AddPinToGuildMember < ActiveRecord::Migration
  def change
    add_column :guild_members, :pin, :integer
  end
end
