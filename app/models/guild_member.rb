class GuildMember < ActiveRecord::Base
  belongs_to :guild
  has_many :items
  has_many :logs
  
  validates_uniqueness_of :name, scope: [:guild_id]
end
