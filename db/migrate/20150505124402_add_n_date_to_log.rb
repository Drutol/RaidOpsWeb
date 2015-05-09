class AddNDateToLog < ActiveRecord::Migration
  def change
    add_column :logs, :n_date, :integer
  end
end
