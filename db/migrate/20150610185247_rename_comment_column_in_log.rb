class RenameCommentColumnInLog < ActiveRecord::Migration
  def change
	rename_column :logs, :strComment, :str_comment
  end
end
