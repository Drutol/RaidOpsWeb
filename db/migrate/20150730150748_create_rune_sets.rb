class CreateRuneSets < ActiveRecord::Migration
  def change
    create_table :rune_sets do |t|
      t.string :name
      t.integer :count
      t.references :guild_member, index: true

      t.timestamps null: false
    end
    add_foreign_key :rune_sets, :guild_members
  end
end
