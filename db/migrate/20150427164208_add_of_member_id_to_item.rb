class AddOfMemberIdToItem < ActiveRecord::Migration
  def change
    add_column :items, :of_member_id, :integer
  end
end
