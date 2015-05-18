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
		begin  
			hash.each do |arr|
	 		 	bFound = false
	 		 	guild_members.each do |member|
	 		 		if member.name == arr['strName']
						member.update(:name => arr['strName'],:ep => arr['EP'],:gp => arr['GP'],:pr => "%.2f"%(arr['EP'].to_f/arr['GP']),:str_class => arr['class'],:str_role => arr['role'],:tot => arr['tot'],:net => arr['net'])
						update_counter += 1
						bFound = true
						if update_counter > 100 then
							raise 'Import failed , maximum value of 100 guild members has been reached.'
						end
	 		 		end
	 		 	end
	 		 	if not bFound
	 		 		guild_members.create(:name => arr['strName'],:ep => arr['EP'],:gp => arr['GP'],:pr => "%.2f"%(arr['EP'].to_f/arr['GP']),:str_class => arr['class'],:str_role => arr['role'],:tot => arr['tot'],:net => arr['net'])
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
	 						member.items.create(:ingame_id => item['itemID'],:timestamp => item['nDate'],:of_member_id => member.id.to_i,:of_guild_id => id.to_i,:gp_cost => item['nGP'])
	 						item_counter += 1
	 						if item_counter > 50 then
								#raise 'Import failed , your export string is not compliant with specifications (Loot Log count > 50).'
							end
	 					end
	 				end 				
	 				if arr['logs'] and member.name == arr['strName'] then
	 					member.logs.delete_all
	 					arr['logs'].each do |log|
	 						if not log['nDate'] and log['strTimestamp'] then
	 							member.logs.create(:strComment => log['strComment'],:strTimestamp => log['strTimestamp'],:strType => log['strType'],:strModifier => log['strModifier'])
	 						else
	 							member.logs.create(:strComment => log['strComment'],:n_date => log['nDate'],:strType => log['strType'],:strModifier => log['strModifier'])
	 						end
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

	def update_json
		
		#begin
		  	ftp = Net::FTP.new
			ftp.connect('31.220.16.113')
			ftp.login('u292965448', 'Ik34UXQiiU')
			ftp.passive = true
			filename = "/public_html/guild_json_#{id}.txt"
			raw = StringIO.new('')
			ftp.retrbinary('RETR ' + filename, 4096) { |data|
			raw << data
			}
			raw.rewind

			json_data = JSON.parse(raw.read)
			for arr in json_data do
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

			#ftp = Net::FTP.new('31.220.16.113')
			#ftp.passive = true
			#ftp.login('u292965448', ENV['FTP_PASS'])
			ftp.puttextcontent(JSON.generate(json_data), "/public_html/guild_json_#{id}.txt")
			ftp.close
		#rescue

		#end
		return "Success"
	end

	validates :name, presence: true
	validates :owner, presence: true
	validates :realm, length: {minimum: 2}

	
	has_many  :guild_members
 	validates_uniqueness_of :name
 	

 end
