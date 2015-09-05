class AddStrGroupToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :str_group, :string
  end
end
