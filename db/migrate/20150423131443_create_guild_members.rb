class CreateGuildMembers < ActiveRecord::Migration
  def change
    create_table :guild_members do |t|
      t.string :name
      t.integer :ep
      t.integer :gp
      t.references :guild, index: true

      t.timestamps null: false
    end
    add_foreign_key :guild_members, :guilds
  end
end
