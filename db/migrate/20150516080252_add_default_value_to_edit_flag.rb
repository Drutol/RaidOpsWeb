class AddDefaultValueToEditFlag < ActiveRecord::Migration
  def change
	change_column :guild_members, :edit_flag, :integer, :default => nil
  end
end
