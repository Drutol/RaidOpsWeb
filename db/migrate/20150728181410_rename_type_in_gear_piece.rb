class RenameTypeInGearPiece < ActiveRecord::Migration
  def change
	rename_column :gear_pieces, :type, :item_type
  end
end
