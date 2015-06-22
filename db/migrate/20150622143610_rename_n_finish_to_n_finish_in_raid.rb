class RenameNFinishToNFinishInRaid < ActiveRecord::Migration
  def change
	rename_column :raids, :nFinish, :n_finish
	rename_column :raids, :nTime, :n_time
  end
end
