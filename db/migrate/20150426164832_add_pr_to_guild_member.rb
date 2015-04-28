class AddPrToGuildMember < ActiveRecord::Migration
  def change
    add_column :guild_members, :pr, :float
  end
end
