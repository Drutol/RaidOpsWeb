class EditAttendance < ActiveRecord::Migration
  def change
	add_column :guild_members, :p_ga, :integer
	add_column :guild_members, :p_ds, :integer
	add_column :guild_members, :p_y, :integer
	add_column :guild_members, :p_tot, :integer
  end
end
