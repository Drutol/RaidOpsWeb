class GuildMember < ActiveRecord::Base
  belongs_to :guild
  has_many :items
  has_many :logs
  
	#validates_uniqueness_of :name, scope: [:guild_id]
	validates :ep, presence: true
	validates :gp, presence: true

	def commit
		source = GuildMember.find(id)
		target = GuildMember.find(source.edit_flag)

		if source and target then
			ep_gain = source.ep - target.ep
			gp_gain = source.gp - target.gp
			comment = ""
			strModifier = ""
			if ep_gain == 0 and gp_gain != 0 then
				if gp_gain > 0 then
					comment = "Add GP"
				else
					comment = "Subtract GP"
				end
				strModifier = gp_gain.to_s
			elsif gp_gain == 0 and ep_gain != 0 then
				if ep_gain > 0 then
					comment = "Add EP"
				else
					comment = "Subtract EP"
				end
				strModifier = ep_gain.to_s
			elsif ep_gain == 0 and gp_gain == 0 then
				strModifier = "Other"
			else #both different
				if gp_gain > 0 then
					comment = "Add GP "
				else
					comment = "Subtract GP "
				end

				if ep_gain > 0 then
					comment += "Add EP"
				else
					comment += "Subtract EP"
				end

				strModifier = gp_gain.to_s + " " + ep_gain.to_s
			end

			target.update_attributes(:ep => source.ep,:gp => source.gp,:net => source.net,:tot => source.tot,:str_class => source.str_class,:str_role => source.str_role)
			source.destroy
			target.logs.create(:strComment => comment,:strType => "{Website}",:strModifier => strModifier,:guild_member_id => target.id,:n_date => Time.now.to_i)
			return 1
		else
			return 0
		end

	end
end
