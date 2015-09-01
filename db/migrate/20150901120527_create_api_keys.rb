class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :key
      t.references :guild, index: true

      t.timestamps null: false
    end
    add_foreign_key :api_keys, :guilds
  end
end
