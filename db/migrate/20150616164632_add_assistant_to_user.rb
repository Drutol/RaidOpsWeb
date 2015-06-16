class AddAssistantToUser < ActiveRecord::Migration
  def change
    add_column :users, :assistant, :integer
  end
end
