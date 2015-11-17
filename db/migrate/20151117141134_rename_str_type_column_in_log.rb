class RenameStrTypeColumnInLog < ActiveRecord::Migration
  def change
	rename_column :logs, :strType, :str_type
  end
end
