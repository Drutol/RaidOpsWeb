class AddAltRefToGearPiece < ActiveRecord::Migration
  def change
    add_reference :gear_pieces, :alt, index: true
    add_foreign_key :gear_pieces, :alts
  end
end
