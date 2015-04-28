class Guild < ActiveRecord::Base
	require 'fileutils'

	def import(params)

		create_counter = 0
		update_counter = 0
		item_counter = 0
		log_counter = 0

		begin
			hash = JSON.parse(params[:json])
		rescue
			return "fail"
		end
		
		path = "#{Rails.root.to_s}/app/guild_data/json_import/guild_#{params[:id]}.txt"

		File.open(path, "w+") do |f|
		  f.write(params[:json])
		end
		begin  
			hash.each do |arr|
	 		 	bFound = false
	 		 	guild_members.each do |member|
	 		 		if member.name == arr['strName']
						member.update(:name => arr['strName'],:ep => arr['EP'],:gp => arr['GP'],:pr => "%.2f"%(arr['EP'].to_f/arr['GP']),:strClass => arr['class'])
						update_counter += 1
						bFound = true
						if update_counter > 100 then
							raise 'Import failed , maximum value of 100 guild members has been reached.'
						end
	 		 		end
	 		 	end
	 		 	if not bFound
	 		 		guild_members.create(:name => arr['strName'],:ep => arr['EP'],:gp => arr['GP'],:pr => "%.2f"%(arr['EP'].to_f/arr['GP']),:strClass => arr['class'])
	 		 		create_counter += 1
	 		 		if create_counter > 100 then
						raise 'Import failed , maximum value of 100 guild members has been reached.'
					end
	 		 	end
	 		end

	 		hash.each do |arr|
	 			guild_members.each do |member|
	 				if arr['tLLogs'] and member.name == arr['strName'] then
	 					member.items.delete_all
	 					arr['tLLogs'].each do |item|
	 						member.items.create(:ingame_id => item['itemID'],:timestamp => item['nDate'],:of_member_id => member.id.to_i,:of_guild_id => id.to_i,:gp_cost => 2)
	 						item_counter += 1
	 						if item_counter > 50 then
								#raise 'Import failed , your export string is not compliant with specifications (Loot Log count > 50).'
							end
	 					end
	 				end 				
	 				if arr['logs'] and member.name == arr['strName'] then
	 					member.logs.delete_all
	 					arr['logs'].each do |log|
	 						member.logs.create(:strComment => log['strComment'],:strTimestamp => log['strTimestamp'],:strType => log['strType'],:strModifier => log['strModifier'])
	 						log_counter += 1
	 						if log_counter > 20 then
								#raise 'Import failed , your export string is not compliant with specifications (Logs count > 20).'
							end
	 					end
	 				end
	 			end
	 		end
	 	rescue Exception => e 
	 		return e.message
	 	end

 		return "success" , create_counter , update_counter , log_counter , item_counter
	end

	validates :name, presence: true
	validates :owner, presence: true
	validates :realm, length: {minimum: 2}

	
	has_many  :guild_members
 	validates_uniqueness_of :name
 	

 end
