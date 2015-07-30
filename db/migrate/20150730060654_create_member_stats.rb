class CreateMemberStats < ActiveRecord::Migration
  def change
    create_table :member_stats do |t|
      t.integer :mox
      t.integer :brut
      t.integer :grit
      t.integer :tech
      t.integer :fin
      t.integer :ins
      t.references :guild_member, index: true

      t.timestamps null: false
    end
    add_foreign_key :member_stats, :guild_members
  end
end
