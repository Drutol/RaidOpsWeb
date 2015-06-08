class CreateRaids < ActiveRecord::Migration
  def change
    create_table :raids do |t|
      t.string :name
      t.integer :nTime
      t.integer :nFinish
      t.integer :nRaidType
      t.references :guild, index: true

      t.timestamps null: false
    end
    add_foreign_key :raids, :guilds
  end
end
