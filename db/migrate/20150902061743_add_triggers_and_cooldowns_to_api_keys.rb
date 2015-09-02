class AddTriggersAndCooldownsToApiKeys < ActiveRecord::Migration
  def change
    add_column :api_keys, :cooldown, :integer
    add_column :api_keys, :triggered, :integer
  end
end
