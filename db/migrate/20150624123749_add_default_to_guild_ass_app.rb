class AddDefaultToGuildAssApp < ActiveRecord::Migration
  def change
     change_column :guilds, :ass_app, :string , :default => ""
  end
end
