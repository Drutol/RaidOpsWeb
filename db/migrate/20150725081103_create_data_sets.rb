class CreateDataSets < ActiveRecord::Migration
  def change
    create_table :data_sets do |t|
      t.string :str_group
      t.float :ep
      t.float :gp
      t.float :pr
      t.float :net
      t.float :tot
      t.references :GuildMember

      t.timestamps null: false
    end
  end
end
