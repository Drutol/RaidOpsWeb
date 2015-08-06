class AddAltRefToRuneSets < ActiveRecord::Migration
  def change
    add_reference :rune_sets, :alt, index: true
    add_foreign_key :rune_sets, :alts
  end
end
