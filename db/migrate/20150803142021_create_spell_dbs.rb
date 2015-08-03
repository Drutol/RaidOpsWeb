class CreateSpellDbs < ActiveRecord::Migration
  def change
    create_table :spell_dbs do |t|
      t.integer :spell_id
      t.string :name

      t.timestamps null: false
    end
  end
end
