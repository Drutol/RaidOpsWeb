class AddAfterToLog < ActiveRecord::Migration
  def change
    add_column :logs, :n_after, :integer
  end
end
