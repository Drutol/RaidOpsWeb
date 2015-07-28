class CreateGearRunes < ActiveRecord::Migration
  def change
    create_table :gear_runes do |t|
      t.integer :rune_id
      t.references :gear_piece, index: true

      t.timestamps null: false
    end
    add_foreign_key :gear_runes, :gear_pieces
  end
end
