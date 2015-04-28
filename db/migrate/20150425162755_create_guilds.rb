class CreateGuilds < ActiveRecord::Migration
	change_table :guilds do |t|
	  t.string :name
	  t.string :owner

	end
end
