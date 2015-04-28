class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :ingame_id
      t.integer :timestamp
      t.references :guild_member, index: true

      t.timestamps null: false
    end
    add_foreign_key :items, :guild_members
  end
end
