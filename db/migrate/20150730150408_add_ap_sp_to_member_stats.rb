class AddApSpToMemberStats < ActiveRecord::Migration
  def change
    add_column :member_stats, :ap, :integer
    add_column :member_stats, :sp, :integer
  end
end
