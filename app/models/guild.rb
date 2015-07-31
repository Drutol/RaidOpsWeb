class Guild < ActiveRecord::Base
	require 'fileutils'

	def import(params)

		create_counter = 0
		update_counter = 0
		item_counter = 0
		log_counter = 0
		player_logs = Hash.new
		player_gear = Hash.new
		player_stats = Hash.new
		player_rune_sets = Hash.new
		player_pin = Hash.new
		begin
			hash = JSON.parse(params[:json])
		rescue
			return "fail"
		end
		begin
			
			Item.where(:of_guild_id => params[:id].to_i).destroy_all
			for guild_member in guild_members do
				bFound = false
				for member in hash['tMembers'] do
					if member['strName'] == guild_member.name then 
						bFound = true 
						break 
					end
				end
				if not bFound then
					guild_member.attendances.destroy_all
					guild_member.member_stats.destroy_all
					guild_member.rune_sets.destroy_all
					guild_member.logs.destroy_all
					for piece in guild_member.gear_pieces do
						piece.gear_runes.destroy_all
						piece.destroy
					end
					for alt in guild_member.alts do alt.destroy end
					guild_member.destroy
				end
			end
		 	
		 	raids.delete_all
	 		if hash.has_key?("tRaids") then
	 			hash['tRaids'].each do |raid|
	 				raids.create(:name => (raid['name'] or "Raid"),:n_time => raid['length'],:n_finish => raid['finishTime'],:raid_type => raid['raidType']) if raid['raidType']
	 			end
	 		end
			hash = hash['tMembers']



			hash.each do |arr|
				member = guild_members.find_by_name(arr['strName'])
				if member then
					member.update_attributes(:ep => arr['EP'],:gp => arr['GP'],:pr => "%.#{pr_precision}f"%(arr['EP'].to_f/arr['GP'].to_f),:str_class => arr['class'],:str_role => arr['role'],:tot => arr['tot'],:net => arr['net'])
				else
 		 			member = guild_members.create(:name => arr['strName'],:ep => arr['EP'],:gp => arr['GP'],:pr => "%.#{pr_precision}f"%(arr['EP'].to_f/arr['GP'].to_f),:str_class => arr['class'],:str_role => arr['role'],:tot => arr['tot'],:net => arr['net'])
 		 		end
 		 		create_counter += 1

 		 		if create_counter > 100 then
					raise 'Import failed , maximum value of 100 guild members has been reached.'
				end
	 		end

			ga_total = raids.where("raid_type = 0").count
			ds_total = raids.where("raid_type = 1").count
			y_total = raids.where("raid_type = 2").count
			totalRaids = raids.count

	 		hash.each do |arr|
	 			guild_members.each do |member|
	 				if arr['tLLogs'] and member.name == arr['strName'] then
	 					member.items.delete_all
	 					arr['tLLogs'].each do |item|
	 						member.items.create(:ingame_id => item['itemID'],:timestamp => item['nDate'],:of_member_id => member.id.to_i,:of_guild_id => id.to_i,:gp_cost => item['nGP'])
	 						item_counter += 1
	 						if item_counter > 50 then
								#raise 'Import failed , your export string is not compliant with specifications (Loot Log count > 50).'
							end
	 					end
	 				end 				
	 				if arr['logs'] and member.name == arr['strName'] then
	 					arr['logs'].each do |log|
	 						if log['nDate'] and not member.logs.where("n_date = ? and str_comment = ?",log['nDate'],log['strComment']).first then
		 						if not log['nAfter'] then after = 0 else after = log['nAfter'] end

		 						member.logs.create(:str_comment => log['strComment'],:n_date => log['nDate'],:strType => log['strType'],:strModifier => log['strModifier'],:n_after => after)

		 						log_counter += 1
		 						if log_counter > 20 then
									#raise 'Import failed , your export string is not compliant with specifications (Logs count > 20).'
								end
							end
	 					end
	 				end
	 				if arr['tDataSets'] and member.name == arr['strName'] then
	 					member.data_sets.delete_all
	 					arr['tDataSets'].each do |set|
	 						member.data_sets.create(:str_group => set['strGroup'],:ep => set['tData']['EP'],:gp => set['tData']['GP'],:net => set['tData']['net'],:tot => set['tData']['tot'],:pr => "%.#{pr_precision}f"%(set['tData']['EP'].to_f/set['tData']['GP'].to_f))
	 					end
	 				end	 				
	 				if arr['alts'] and member.name == arr['strName'] then
	 					member.alts.destroy_all
	 					arr['alts'].each do |alt|
	 						member.alts.create(:name => alt)
	 					end
	 				end	 				
	 				if arr['tArmoryEntry'] and member.name == arr['strName'] and arr['tArmoryEntry'].keys.length > 2 then
		 				for piece in member.gear_pieces do
							piece.gear_runes.destroy_all
							piece.destroy
						end

	 					for key in arr['tArmoryEntry'].keys do
							if key == "tStats" then
								member.member_stats.destroy_all
								member.member_stats.create(:mox =>arr['tArmoryEntry'][key]['Mox'],:brut => arr['tArmoryEntry'][key]['Bru'],:ins => arr['tArmoryEntry'][key]['Wis'],:tech =>arr['tArmoryEntry'][key]['Tech'],:fin =>arr['tArmoryEntry'][key]['Dex'],:grit => arr['tArmoryEntry'][key]['Sta'],:ap => arr['tArmoryEntry'][key]['AP'],:sp => arr['tArmoryEntry'][key]['SP'])
							elsif key == "tSets"
								member.rune_sets.destroy_all
								for set_key in arr['tArmoryEntry'][key].keys do
									member.rune_sets.create(:name => set_key,:count => arr['tArmoryEntry'][key][set_key])
								end
							else
								item = arr['tArmoryEntry'][key]
								piece = member.gear_pieces.create(:item_id => item['id'],:item_type => key)
								item["runes"].each do |rune|
									piece.gear_runes.create(:rune_id => rune)
								end
							end
						end
	 				end
	 				if arr['tAtt'] and member.name == arr['strName'] then
	 					member.attendances.delete_all
	 					arr['tAtt'].each do |att|
	 						member.attendances.create(:raid_type => att['raidType'],:nSecs => att['nSecs'],:n_time => att['nTime']) if att['raidType']
	 					end
	 					ga_count = member.attendances.where("raid_type = 0").count
						ds_count = member.attendances.where("raid_type = 1").count
						y_count = member.attendances.where("raid_type = 2").count
						all = ga_count+ds_count+y_count
						
	 					p_ga = 0
						p_ds = 0
						p_y = 0
						p_tot = 0

						p_ga = (ga_count*100)/ga_total if ga_total > 0
						p_ds = (ds_count*100)/ds_total if ds_total > 0 
						p_y = (y_count*100)/y_total if y_total > 0
						p_tot = (all*100)/totalRaids if totalRaids > 0
						#if member.name == "Sing Child" then raise "Summary #{ga_count} , #{ds_count} , #{y_count} , #{p_ga} ,#{p_ds} , #{p_y} , #{p_tot}" end
						begin
							member.update_attributes!(:p_ga => p_ga,:p_ds => p_ds,:p_y => p_y,:p_tot => p_tot)
						rescue 
	 						member.update_attribute(:p_ga,p_ga)
	 						member.update_attribute(:p_ds,p_ds)
	 						member.update_attribute(:p_y,p_y)
	 						member.update_attribute(:p_tot,p_tot)
	 					end
	 				end
	 			end
	 		end

			for member in guild_members do
				for log in member.logs do
	 				if Time.now.to_i - log.n_date.to_i  > 604800 then log.destroy end
	 			end
	 		end

	 	rescue Exception => e 
	 		return e.message
	 	end

 		return "success" , create_counter , log_counter , item_counter
	end

	def update_json
		
		begin
		  	ftp = Net::FTP.new
			ftp.connect('31.220.16.113')
			ftp.login('u292965448', ENV['FTP_PASS'])
			ftp.passive = true
			filename = "/public_html/guild_json_#{id}.txt"
			raw = StringIO.new('')
			ftp.retrbinary('RETR ' + filename, 4096) { |data|
			raw << data
			}
			raw.rewind

			json_data = JSON.parse(raw.read)
			for arr in json_data['tMembers'] do
				for member in guild_members do
					if member.name.to_s == arr['strName'].to_s then# and member.differ?(arr) then
						arr['EP'] = member.ep
						arr['GP'] = member.gp
						arr['net'] = member.net
						arr['tot'] = member.tot
						arr['strClass'] =  member.str_class 
						arr['strRole'] = member.str_role
						break
					end
				end
			end

			ftp.puttextcontent(JSON.generate(json_data), "/public_html/guild_json_#{id}.txt")
			ftp.close
		rescue
			return "Data not updated , if problem persists notify me via issue tracker."
		end
		return "Data updated , download new data and sync with in-game addon."
	end

	validates :name, presence: true
	validates :owner, presence: true
	validates :realm, length: {minimum: 2}

	
	has_many :guild_members
	has_many :raids
 	validates_uniqueness_of :name
 	

 end
