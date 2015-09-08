class GuildsController < ApplicationController
	require 'net/ftp'
	require 'stringio'
	require 'securerandom'
	skip_before_filter :require_login, only: [:index, :show,:items_all,:download,:recent_activity,:attendance,:raids,:ad_profiles]
 	before_filter do
	    if request.host != "www.raidops.net" && Rails.env.production? then redirect_to "http://raidops.net" end
            if request.ssl? && Rails.env.production?
	      redirect_to :protocol => 'http://', :status => :moved_permanently
	    end
  	end

	def new
		#redirect_to guilds_path , notice: "Sorry but the website is currently on free hosting and there's no more space , if you want to help read this https://github.com/Mordonus/RaidOps/issues/185"
		if User.find_by_email(current_user.email).guild_id != nil then
			redirect_to Guild.find(User.find_by_email(current_user.email).guild_id) , notice: 'You have already created guild , remove this one first'
		else
			@guild = Guild.new
		end
	end

	def show
   		@guild = Guild.find(params[:id])
   		members = Array.new
   		@edited = Array.new
   		@sets = Array.new 
   		@values = Hash.new  		
   		for member in @guild.guild_members do
   			@values[member.name] = Hash.new 
   			if member.data_sets then
   				for set in member.data_sets do
   					if not @sets.index(set.str_group) then 
   						@sets.push(set.str_group) 		
   					end
   					@values[member.name][set.str_group] = set
   				end
   			end
   			if not params[:set] then
	   			begin
	            	edit_member = GuildMember.find_by(edit_flag: member.id)
	   			if edit_member then
	   				members.push(edit_member.id)
	   				@edited.push(edit_member.id)
	   			elsif member.name != "Guild Bank" then
	   				members.push(member.id)
	   			end
				rescue
					members.push(member.id)
				end
			else
				for set in member.data_sets do
   					if set.str_group == params[:set] then 
   						members.push(member.id) 
   						break 
   					end
   				end
			end
   		end
   		if not @guild.ass_app then @guild.update_attribute(:ass_app,"") end
   			
   		@members_grid = initialize_grid(GuildMember.where(id: members),:order => if @guild.mode == "EPGP" then if params[:set] then 'data_sets.pr' else 'guild_members.pr' end elsif @guild.mode == "DKP" then 'guild_members.net' else 'guild_members.name' end,:order_direction => if @guild.mode == "Armory" then'asc' else 'desc' end,:per_page => @guild.members_per_page,:include => 'data_sets')

  	end

  	def ad_profiles
  		@guild = Guild.find(params[:id])
  	end

  	def set_ads_profile
  		Guild.find(params[:id]).update_attribute(:add_profile,params[:ad_profile])
  		redirect_to ad_profiles_guild_path(params[:id])
  	end

  	def index
  		@active_guilds = Array.new
  		@inactive_guilds = Array.new
  		for guild in Guild.all do 
  			if guild.guild_members.count > 0 and Time.now.to_i - guild.updated_at.to_i < 1209600 then 
  				@active_guilds.push(guild.id)
  			else
				@inactive_guilds.push(guild.id)
  			end
  		end
  		@active_guilds_grid = initialize_grid(Guild.where(id:  @active_guilds),:order => 'guilds.name',:name =>"aguilds")
  		@inactive_guilds_grid = initialize_grid(Guild.where(id:  @inactive_guilds),:order => 'guilds.name',:name =>"iguilds")
  	end
  	
  	def download
  		begin
	  		f = ""
		  	ftp = Net::FTP.new
			ftp.connect('85.17.73.180')
			ftp.login(ENV['FTP_USER'], ENV['FTP_PASS'])
			ftp.passive = true
			filename = "/public_html/guild_json_#{params[:id]}.txt"
			raw = StringIO.new('')
			ftp.retrbinary('RETR ' + filename, 4096) { |data|
			raw << data
			}
			ftp.close
			raw.rewind
			send_data raw.read, :filename => "guild_json_#{params[:id]}.txt"
		rescue
	 		redirect_to Guild.find(params[:id]) , notice: 'Download failed'
	 	end
	end

  	def items_all
  	  @guild = Guild.find(params[:id])
  	  @itemHash = Hash.new
  	  ids = Array.new
  	  for member in @guild.guild_members do
  	  	for item in member.items do
  	  		@itemHash[item.timestamp] = member.id
  	  		ids.push(item.id)
  	  	end
  	  end


      @items_grid = initialize_grid(Item.where(id: ids),:include => :guild_member,:order => 'items.timestamp' ,:order_direction => 'desc',:per_page => @guild.items_per_page)
    end

    def recent_activity
    	@guild = Guild.find(params[:id])
    	@timeline_data = Hash.new
    	@EP_gain_data = Hash.new
    	@GP_gain_data = Hash.new
    	@log = Log.where("n_date = ?",params[:event])[0] if params[:event]
    	for member in @guild.guild_members do
    		for log in member.logs do
	    		if log.n_date and not @timeline_data[log.n_date.to_i] then
	    			@timeline_data[log.n_date.to_i] = {:event => log.str_comment , :y => 1 ,:time => log.n_date.to_i}
	    		elsif log.n_date then
					@timeline_data[log.n_date.to_i][:y] += 1 if @timeline_data[log.n_date.to_i][:event] == log.str_comment
	    		end

	    		if log.strType == '{EP}' then
		    		if log.n_date and not @EP_gain_data[log.n_date.to_i] then
						@EP_gain_data[log.n_date.to_i] = {:event => log.str_comment , :y => log.strModifier.to_i ,:time => log.n_date.to_i}
		    		elsif log.n_date then
						@EP_gain_data[log.n_date.to_i][:y] += log.strModifier.to_i
		    		end
				elsif log.n_date then
					@EP_gain_data[log.n_date.to_i] = nil
				end	
	    	end
    	end
		dates = Array.new
		affected_counts = Array.new
		ep_counts = Array.new
		removed_keys = Array.new
		nMaxEvents = @guild.max_events
		counter = 1
		for key in @timeline_data.keys.sort_by { |time, affected| time }.reverse do
			if counter <= nMaxEvents then
				if @timeline_data[key][:y] >= @guild.min_affected
					dates.insert(0,Time.at(key).strftime('%d/%m/%Y , %T'))
					affected_counts.insert(0,@timeline_data[key])
					counter += 1
				else
					removed_keys.push(key)
				end
			else removed_keys.push(key) end
		end	

		for key in @EP_gain_data.keys.sort_by { |time, affected| time }.reverse do
			if not removed_keys.index(key)
				ep_counts.insert(0,@EP_gain_data[key]) 
			end
		end	

		@chart = LazyHighCharts::HighChart.new('graph') do |f|
		  f.title(:text => "Recent activity")
		  f.xAxis(:categories => dates)
		  f.series(:name => "Affected", :yAxis => 0, :data => affected_counts)
		  f.series(:name => "EP gain", :yAxis => 1, :data => ep_counts)

		  f.yAxis [
		    {:title => {:text => "Affected", :margin => 70} },
		    {:title => {:text => "EP gain"}, :opposite => true},
		  ]

		  f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
		  f.chart({:defaultSeriesType=>"line"})
		    f.plotOptions({
		        series:{
		            cursor: 'pointer',
		            connectNulls: true,
		             point: {
		                  events: {
		                            click: %| function(){ 
		                                   alert(window.location.hostname + '/guilds/' + this.guild_id + '/recent_activity/' + this.time);
		                          } |.js_code
		                  }
		              }
		          }
		      })
   
		end
		if params[:event] then
			@affected = Array.new
			for log in Log.where("n_date = #{params[:event]}") do
				@affected.push(log.guild_member_id) if not @affected.index(log.guild_member_id)
			end
			@members_grid = initialize_grid(@guild.guild_members.where(id: @affected),:per_page => @guild.members_per_page)
		end
    end

    def update_settings
    	Guild.find(params[:id]).update_attributes(:min_affected => params[:min_aff] , :max_events => params[:max_ev])
    	redirect_to recent_activity_guild_path(params[:id])
    end

  	def edit
  		@guild = Guild.find(params[:id])
	end

	def create
	  	@guild =  Guild.new(guild_params)
	 
	 	if @guild.save
			User.find_by_email(current_user.email).update_attribute(:guild_id , @guild.id)

	 		redirect_to @guild , notice: 'Guild created'
	 	else
	 		render 'new' ,  notice: 'Guild creation fail'
	 	end
	end

	def update
	  @guild = Guild.find(params[:id])
	 
	  if @guild.update(guild_params)
	    redirect_to @guild
	  else
	    render 'edit'
	  end
	end

	def destroy
		@guild = Guild.find(params[:id])
		Item.where(:of_guild_id => params[:id].to_i).destroy_all
		for guild_member in @guild.guild_members do
			guild_member.logs.destroy_all
			guild_member.attendances.destroy_all
		end
		@guild.raids.destroy_all
		@guild.guild_members.each do |guild_member|
			guild_member.attendances.destroy_all
			guild_member.member_stats.destroy_all
			guild_member.rune_sets.destroy_all
			guild_member.logs.destroy_all
			guild_member.data_sets.destroy_all
			for piece in guild_member.gear_pieces do
				piece.gear_runes.destroy_all
				piece.destroy
			end
			for alt in guild_member.alts do
				alt.gear_pieces.each do |piece|
					piece.gear_runes.destroy_all
					piece.destroy
				end
					alt.rune_sets.destroy_all
					alt.member_stats.destroy_all
					alt.destroy
				end
			guild_member.destroy
		end
		@guild.api_keys.destroy_all
		@guild.destroy
		User.find_by_email(current_user.email).update_attribute(:guild_id , nil)
		redirect_to guilds_path , notice: 'Guild deleted successfully.'
	end

	class Net::FTP
	  def puttextcontent(content, remotefile, &block)
	    f = StringIO.new(content)
	    begin
	      storlines("STOR " + remotefile, f, &block)
	    ensure
	      f.close
	    end
	  end
	end


	def upload
		@guild = Guild.find(params[:id])
	end

	def import
		@guild = Guild.find(params[:id])
		strState , c_counter , l_counter , i_counter = @guild.import(params)
		if strState == "success" then
			Guild.find(params[:id]).update_attributes(:updated_at => DateTime.now)

			begin
				hash = JSON.parse(params[:json])
				for member in hash['tMembers'] do
					member['tArmoryEntry'] = nil
				end
				hash = JSON.generate(hash)
				ftp = Net::FTP.new('85.17.73.180')
				ftp.passive = true
				ftp.login(ENV['FTP_USER'], ENV['FTP_PASS'])
				ftp.puttextcontent(hash, "/public_html/guild_json_#{params[:id]}.txt")
				ftp.close
			rescue
				redirect_to @guild , notice: "Import successfull: Processed #{c_counter.to_s} entries . Processed #{i_counter} items and #{l_counter} logs. Backup file upload failed."
				return
			end

			redirect_to @guild , notice: "Import successfull: Created #{c_counter.to_s} entries . Processed #{i_counter} items and #{l_counter} logs. Backup file successfully uploaded."
		elsif strState == "fail" then
			redirect_to upload_guild_path(@guild) , notice: 'Invalid data'
		else
			redirect_to upload_guild_path(@guild) , notice: strState
		end
	end

	def review_changes
		@guild = Guild.find(params[:id])
		@members_grid = initialize_grid(GuildMember.where("guild_id = #{params[:id]} and edit_flag IS NOT NULL"),:per_page => @guild.members_per_page)
		
	end

	def commit_all
		for member in GuildMember.where("guild_id = #{params[:id]} and edit_flag IS NOT NULL") do
			member.commit(false)
		end
		strState = Guild.find(params[:id]).update_json
		redirect_to guild_path(params[:id]), notice: strState
	end

	def undo_all
		for member in GuildMember.where("guild_id = #{params[:id]} and edit_flag IS NOT NULL") do
			member.destroy
			redirect_to guild_path(params[:id])
		end
	end

	def attendance
		@guild = Guild.find(params[:id])
		@ga_total = @guild.raids.where("raid_type = 0").count
		@ds_total = @guild.raids.where("raid_type = 1").count
		@y_total = @guild.raids.where("raid_type = 2").count
		@totalRaids = @guild.raids.count

		ids = Array.new
		for member in @guild.guild_members do
			ids.push(member.id) if member.attendances.count > 0
		end


		@members_grid = initialize_grid(GuildMember.where(id: ids),:order => 'guild_members.p_tot',:order_direction => 'desc')
	end

	def raids
		@guild = Guild.find(params[:id])
		if params[:raid] then
			@raid = Raid.find(params[:raid].to_i)
			member_ids = Array.new
			item_ids = Array.new
			@item_owners = Hash.new
			for member in @guild.guild_members do
				for att in member.attendances do
					if @raid.n_finish == att.n_time then member_ids.push(member.id) end
				end
			end
			for member in @guild.guild_members do
				for item in member.items do
					if item.timestamp > (@raid.n_finish - @raid.n_time) and item.timestamp < @raid.n_finish then 
						item_ids.push(item.id) 
						@item_owners[item.timestamp] = member.id 
					end
				end
			end
			@members_grid = initialize_grid(GuildMember.where(id: member_ids),:include => :attendances,:name => 'members_grid',:order => if @guild.mode == "EPGP" then 'guild_members.pr' else 'guild_members.net' end,:order_direction => 'desc',:per_page => @guild.members_per_page) 
			@items_grid = initialize_grid(Item.where(id: item_ids),:name => 'items_grid',:order => 'items.timestamp',:order_direction => 'desc',:per_page => @guild.items_per_page)
		end
	end

	def assistant_apply
		guild = Guild.find(params[:id])

		app_mails = guild.ass_app
		if not app_mails then app_mails = "" end
		new_apps = ""
		if not app_mails.include?(current_user.email) then
			new_apps += app_mails + ";" + current_user.email
		else
			app_mails.split(';').each do |app|
				if app != current_user.email then
					new_apps += ";" + app
				end
			end
		end

		guild.update_attribute(:ass_app,new_apps)

		redirect_to guild_path(params[:id])
	end

	def ass_applications
		@guild = Guild.find(params[:id])

		@assIds = Array.new

		for user in User.all do
			if user.assistant == params[:id].to_i then @assIds.push(user.id) end
		end
	end

	def reject_ass 
		guild = Guild.find(params[:id])
		
		app_mails = guild.ass_app
		new_apps = ""
		app_mails.split(';').each do |app|
			if app != params[:email].to_s then
				new_apps += ";" + app
			end
		end
		guild.update_attribute(:ass_app,new_apps)
		redirect_to ass_applications_guild_path(guild)
	end

	def add_ass
		guild = Guild.find(params[:id])
		
		app_mails = guild.ass_app
		new_apps = ""
		app_mails.split(';').each do |app|
			if app != params[:email].to_s then
				new_apps += ";" + app
			end
		end
		guild.update_attribute(:ass_app,new_apps)
		User.where("email = ?",params[:email]).first.update_attribute(:assistant,guild.id)

		redirect_to ass_applications_guild_path(guild)
	end

	def rem_ass 
		User.find(params[:ass_id]).update_attribute(:assistant,nil)
		redirect_to ass_applications_guild_path(params[:id])
	end

	def settings
		@guild = Guild.find(params[:id])
	end

	def set_main_settings
		guild = Guild.find(params[:id])
		pr_precision =1
		begin
			pr_precision = Float(params[:pr_precision])
		rescue
			pr_precision = 1
		end
		guild.update_attributes(:pr_precision => pr_precision.to_i ,:members_per_page => params[:members_per_page],:items_per_page => params[:items_per_page],:auto_raid_name => params[:auto_raid_name])

		redirect_to guild_path(params[:id])
	end

	def show_pins
		@guild = Guild.find(params[:id])
		for member in @guild.guild_members do
			if not member.pin then
				member.update_attribute(:pin,rand(1000..9999))
			end
		end
		@members_grid = initialize_grid(@guild.guild_members,:order =>'guild_members.name',:order_direction => 'ASC')
	end

	def api_keys
		@guild = Guild.find(params[:id])
	end

	def api_key_new
		random_string = SecureRandom.hex
		guild = Guild.find(params[:id])
		if guild.api_keys.count <= 5 then 
			guild.api_keys.create(:key => random_string)
			redirect_to api_keys_guild_path(params[:id])
		else
			redirect_to api_keys_guild_path(params[:id]) ,notice:  "You can have up to 6 keys."
		end
	end

	def api_key_rem
		Guild.find(params[:id]).api_keys.find(params[:key_id]).destroy
		redirect_to api_keys_guild_path(params[:id])
	end

	def armor_compare
		@guild = Guild.find(params[:id])
		members = Array.new
		for member in @guild.guild_members do
			if member.gear_pieces.count > 4 then
				begin
		        	edit_member = GuildMember.find_by(edit_flag: member.id)
					if edit_member then
						members.push(edit_member.id)
					elsif member.name != "Guild Bank" then
						members.push(member.id)
					end
				rescue
					members.push(member.id)
				end
			end
		end
		@members_grid = initialize_grid(GuildMember.where(id: members),:per_page => 8)
		@slot_order = [16,15,2,3,0,5,1,4,7,8,10,11]

	end

	private
		def guild_params
	  		params.require(:guild).permit(:name, :owner, :realm,:mode)
		end
end
