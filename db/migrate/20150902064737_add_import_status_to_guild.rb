class AddImportStatusToGuild < ActiveRecord::Migration
  def change
    add_column :guilds, :import_status, :string
  end
end
