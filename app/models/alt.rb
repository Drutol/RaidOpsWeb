class Alt < ActiveRecord::Base
  belongs_to :guild_member

  has_many :gear_pieces
  has_many :member_stats
  has_many :rune_sets
end
