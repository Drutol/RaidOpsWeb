class AddRealmToGuild < ActiveRecord::Migration
  def change
    add_column :guilds, :realm, :string
  end
end
