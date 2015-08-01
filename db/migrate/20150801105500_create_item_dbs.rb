class CreateItemDbs < ActiveRecord::Migration
  def change
    create_table :item_dbs do |t|
      t.integer :item_id
      t.string :sprite

      t.timestamps null: false
    end
  end
end
