class AddQualToItemDb < ActiveRecord::Migration
  def change
    add_column :item_dbs, :quality, :integer
  end
end
