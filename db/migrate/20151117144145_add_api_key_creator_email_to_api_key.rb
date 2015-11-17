class AddApiKeyCreatorEmailToApiKey < ActiveRecord::Migration
  def change
    add_column :api_keys, :str_creator, :string
  end
end
