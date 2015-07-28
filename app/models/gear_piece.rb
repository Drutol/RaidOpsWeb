class GearPiece < ActiveRecord::Base
	belongs_to :guild_member
	has_many :gear_runes
end
