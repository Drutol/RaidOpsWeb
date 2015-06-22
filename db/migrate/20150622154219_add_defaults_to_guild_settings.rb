class AddDefaultsToGuildSettings < ActiveRecord::Migration
  def change
     change_column :guilds, :members_per_page, :integer , :default => 20
     change_column :guilds, :items_per_page, :integer , :default => 20
     change_column :guilds, :pr_precision, :integer , :default => 2
  end
end
