class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :strModifier
      t.string :strComment
      t.string :strType
      t.string :strTimestamp
      t.references :guild_member, index: true

      t.timestamps null: false
    end
    add_foreign_key :logs, :guild_members
  end
end
