class CreateAlts < ActiveRecord::Migration
  def change
    create_table :alts do |t|
      t.string :name
      t.references :guild_member, index: true

      t.timestamps null: false
    end
    add_foreign_key :alts, :guild_members
  end
end
