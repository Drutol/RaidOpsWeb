class CreateGearPieces < ActiveRecord::Migration
  def change
    create_table :gear_pieces do |t|
      t.integer :item_id
      t.integer	:type
      t.references :guild_member, index: true

      t.timestamps null: false
    end
  end
end
