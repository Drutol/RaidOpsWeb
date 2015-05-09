class AddModeRecentActivityToGuild < ActiveRecord::Migration
  def change
    add_column :guilds, :mode, :string , default: "EPGP"
    add_column :guilds, :max_events, :integer ,default: 10
    add_column :guilds, :min_affected, :integer ,default: 2
  end
end
