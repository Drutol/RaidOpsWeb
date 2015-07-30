class GuildMember < ActiveRecord::Base
  belongs_to :guild
  has_many :items
  has_many :logs
  has_many :attendances
  has_many :data_sets
  has_many :gear_pieces
  has_many :alts
  has_many :member_stats
  has_many :rune_sets


	def commit(commit_string = true)
		source = GuildMember.find(id)
		target = GuildMember.find(source.edit_flag)

		if source and target then
			ep_gain = source.ep - target.ep
			gp_gain = source.gp - target.gp
			net_gain = source.net - target.net
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
				#DKP maybe?
				if net_gain > 0 then
					comment = "Add DKP"
				elsif net_gain < 0 then
					comment = "Subtract DKP"
				else #finish
					comment = "Other"
				end	
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

			target.update_attributes(:ep => source.ep,:gp => source.gp,:net => source.net,:pr => source.pr,:tot => source.tot,:str_class => source.str_class,:str_role => source.str_role)
			source.destroy
			target.logs.create(:str_comment => comment,:strType => "{Website}",:strModifier => strModifier,:guild_member_id => target.id,:n_date => Time.now.to_i)
			if commit_string then Guild.find(target.guild_id).update_json end
			return 1
		else
			return 0
		end

		def differ?(sample) #hash
			if ep != sample[:ep] or gp != sample[:gp] or net != sample[:net] or tot != sample[:tot] or str_role != sample[:strRole] or str_class != sample[:strClass] then return true else return false end
		end

		def infuse(target)
			target[:ep] = ep
			target[:gp] = gp
			target[:net] = net
			target[:tot] = tot
			target[:strClass] =  str_class 
			target[:strRole] = str_role
		end

		def calculate_attendance(guild)


		end


	end
end
