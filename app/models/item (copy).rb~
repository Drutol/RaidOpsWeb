class Item < ActiveRecord::Base
  belongs_to :guild_member
  validates_uniqueness_of :timestamp, scope: [:guild_member_id]
end
