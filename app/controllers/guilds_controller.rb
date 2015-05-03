class GuildsController < ApplicationController
	require 'net/ftp'
	require 'stringio'

	skip_before_filter :require_login, only: [:index, :show,:items_all]
	def new
		if User.find_by_email(current_user.email).guild_id != nil then
			redirect_to Guild.find(User.find_by_email(current_user.email).guild_id) , notice: 'You have already created guild , remove this one first'
		else
			@guild = Guild.new
		end
	end

	def show
   		@guild = Guild.find(params[:id])
   		@members_grid = initialize_grid(@guild.guild_members.where("name != 'Guild Bank'"),:order => 'guild_members.pr',:order_direction => 'desc')
  	end

  	def index
  		@guilds_grid = initialize_grid(Guild.all)
  	end
  	def download
  		begin
	  		f = ""
		  	ftp = Net::FTP.new
			ftp.connect('31.220.16.113')
			ftp.login('u292965448', ENV['FTP_PASS'])
			ftp.passive = true
			filename = "/public_html/guild_json_#{params[:id]}.txt"
			raw = StringIO.new('')
			ftp.retrbinary('RETR ' + filename, 4096) { |data|
			raw << data
			}
			ftp.close
			raw.rewind
			send_data raw.read, :filename => filename
		rescue
	 		redirect_to Guild.find(params[:id]) , notice: 'Download failed'
	 	end
	end

  	def items_all
  	  @guild = Guild.find(params[:id])
  	  @item_owners = {}
  	  Item.where(of_guild_id: params[:id]).each do |item|
  	  	@item_owners[item.timestamp] = item.of_member_id
  	  end
      @items_grid = initialize_grid(Item.where(of_guild_id: params[:id]),:include => :guild_member)
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
		end
		@guild.guild_members.destroy_all
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
		strState , c_counter , u_counter , l_counter , i_counter = @guild.import(params)
		if strState == "success" then
			Guild.find(params[:id]).update_attributes(:updated_at => DateTime.now)

			begin
				ftp = Net::FTP.new('31.220.16.113')
				ftp.passive = true
				ftp.login('u292965448', ENV['FTP_PASS'])
				ftp.puttextcontent(params[:json], "/public_html/guild_json_#{params[:id]}.txt")
				ftp.close
			rescue
				redirect_to @guild , notice: "Import successfull: Created #{c_counter.to_s} entries , updated #{u_counter.to_s} entries. Processed #{i_counter} items and #{l_counter} logs. Backup file upload failed."
				return
			end

			redirect_to @guild , notice: "Import successfull: Created #{c_counter.to_s} entries , updated #{u_counter.to_s} entries. Processed #{i_counter} items and #{l_counter} logs. Backup file successfully uploaded."
		elsif strState == "fail" then
			redirect_to upload_guild_path(@guild) , notice: 'Invalid data'
		else
			redirect_to upload_guild_path(@guild) , notice: strState
		end
	end

	private
		def guild_params
	  		params.require(:guild).permit(:name, :owner, :realm)
		end
end
