class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.integer :nSecs
      t.integer :nRaidType
      t.references :guild_member, index: true

      t.timestamps null: false
    end
    add_foreign_key :attendances, :guild_members
  end
end
