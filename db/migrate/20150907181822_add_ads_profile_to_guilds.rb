class AddAdsProfileToGuilds < ActiveRecord::Migration
  def change
    add_column :guilds, :add_profile, :string
  end
end
