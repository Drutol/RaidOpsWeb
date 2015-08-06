class AddAltRefToMemberStats < ActiveRecord::Migration
  def change
    add_reference :member_stats, :alt, index: true
    add_foreign_key :member_stats, :alts
  end
end
